import json
import time
import numpy as np
import pandas as pd
import torch

from sqlalchemy.orm import Session

from core.exceptions import PreprocessingError, PredictionError
from core.app_logging import get_logger
from models.churn_model import ChurnPredictionInput, ChurnPredictionResult
from schemas.churn_schema import ChurnRequest
from services.model_loader import get_model, get_device
from services.model_loader import _ModelStore

logger = get_logger(__name__)

# Kolom fitur sesuai urutan dataset
FEATURE_COLUMNS = [
    "account_length", "number_vmail_messages",
    "total_day_minutes", "total_day_calls", "total_day_charge",
    "total_eve_minutes", "total_eve_calls", "total_eve_charge",
    "total_night_minutes", "total_night_calls", "total_night_charge",
    "total_intl_minutes", "total_intl_calls", "total_intl_charge",
    "customer_service_calls", "international_plan", "voice_mail_plan",
]

CONFIDENCE_THRESHOLD = 0.5


# ── Predict ─────────────────────────────────────────────────────
def predict_churn(db: Session, request_data: ChurnRequest) -> dict:
    try:
        input_dict = request_data.model_dump()
        df = pd.DataFrame([{col: input_dict[col] for col in FEATURE_COLUMNS}])
    except Exception as exc:
        raise PreprocessingError(f"Failed to build input DataFrame: {exc}") from exc

    try:
        preprocessor = _ModelStore.preprocessor
        X_transformed = preprocessor.transform(df)
        if hasattr(X_transformed, "toarray"):
            X_transformed = X_transformed.toarray()
        X_tensor = torch.tensor(X_transformed, dtype=torch.float32).to(get_device())
    except PreprocessingError:
        raise
    except Exception as exc:
        raise PreprocessingError(f"Preprocessing failed: {exc}") from exc

    try:
        model = get_model()
        start = time.time()
        with torch.no_grad():
            logits = model(X_tensor)
            prob   = torch.sigmoid(logits).item()
        elapsed_ms = int((time.time() - start) * 1000)

        prediction_label = "Churn" if prob >= CONFIDENCE_THRESHOLD else "Not Churn"
        confidence       = round(prob, 4)
    except Exception as exc:
        raise PredictionError(f"Model inference failed: {exc}") from exc

    # Simpan input ke DB
    application = ChurnPredictionInput(
        account_length         = input_dict["account_length"],
        number_vmail_messages  = input_dict["number_vmail_messages"],
        total_day_minutes      = input_dict["total_day_minutes"],
        total_day_calls        = input_dict["total_day_calls"],
        total_day_charge       = input_dict["total_day_charge"],
        total_eve_minutes      = input_dict["total_eve_minutes"],
        total_eve_calls        = input_dict["total_eve_calls"],
        total_eve_charge       = input_dict["total_eve_charge"],
        total_night_minutes    = input_dict["total_night_minutes"],
        total_night_calls      = input_dict["total_night_calls"],
        total_night_charge     = input_dict["total_night_charge"],
        total_intl_minutes     = input_dict["total_intl_minutes"],
        total_intl_calls       = input_dict["total_intl_calls"],
        total_intl_charge      = input_dict["total_intl_charge"],
        customer_service_calls = input_dict["customer_service_calls"],
        international_plan     = input_dict["international_plan"],
        voice_mail_plan        = input_dict["voice_mail_plan"],
    )
    db.add(application)
    db.flush()

    # Simpan hasil prediksi ke DB
    top_features = _get_feature_importance(df, preprocessor)
    prediction = ChurnPredictionResult(
        input_id            = application.id,
        prediction_label    = prediction_label,
        churn_probability   = confidence,
        inference_time_ms   = elapsed_ms,
    )
    db.add(prediction)
    db.commit()
    db.refresh(application)
    db.refresh(prediction)

    logger.info(
        "Prediction done — id=%d, label=%s, prob=%.4f, time=%dms",
        application.id, prediction_label, confidence, elapsed_ms,
    )

    return _serialize_input(application, prediction, top_features)


# ── Get all ─────────────────────────────────────────────────────
def get_all_predictions(db: Session) -> list:
    inputs = db.query(ChurnPredictionInput).all()
    return [_serialize_input(inp, inp.prediction) for inp in inputs]


# ── Get by ID ────────────────────────────────────────────────────
def get_prediction_by_id(db: Session, prediction_id: int):
    inp = db.query(ChurnPredictionInput).filter(
        ChurnPredictionInput.id == prediction_id
    ).first()
    if not inp:
        return None
    return _serialize_input(inp, inp.prediction)


# ── Feature importance ───────────────────────────────────────────
def _get_feature_importance(df: pd.DataFrame, preprocessor) -> list:
    try:
        transformed = preprocessor.transform(df)
        if hasattr(transformed, "toarray"):
            transformed = transformed.toarray()
        feature_names = preprocessor.get_feature_names_out()
        values        = np.abs(transformed[0])
        pairs = sorted(zip(feature_names, values), key=lambda x: x[1], reverse=True)
        return [{"feature": str(name), "value": round(float(val), 4)} for name, val in pairs[:5]]
    except Exception:
        return []


# ── Serializer ───────────────────────────────────────────────────
def _serialize_input(app: ChurnPredictionInput, result: ChurnPredictionResult = None, features: list = None) -> dict:
    data = {
        "id":                     app.id,
        "account_length":         app.account_length,
        "number_vmail_messages":  app.number_vmail_messages,
        "total_day_minutes":      app.total_day_minutes,
        "total_day_calls":        app.total_day_calls,
        "total_day_charge":       app.total_day_charge,
        "total_eve_minutes":      app.total_eve_minutes,
        "total_eve_calls":        app.total_eve_calls,
        "total_eve_charge":       app.total_eve_charge,
        "total_night_minutes":    app.total_night_minutes,
        "total_night_calls":      app.total_night_calls,
        "total_night_charge":     app.total_night_charge,
        "total_intl_minutes":     app.total_intl_minutes,
        "total_intl_calls":       app.total_intl_calls,
        "total_intl_charge":      app.total_intl_charge,
        "customer_service_calls": app.customer_service_calls,
        "international_plan":     app.international_plan,
        "voice_mail_plan":        app.voice_mail_plan,
        "created_at":             app.created_at.isoformat() if app.created_at else None,
        "prediction":             None,
        "top_features":           features or [],
    }
    if result:
        data["prediction"] = {
            "prediction_label":  result.prediction_label,
            "churn_probability": result.churn_probability,
            "inference_time_ms": result.inference_time_ms,
        }
    return data