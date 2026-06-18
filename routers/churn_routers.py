from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from core.databases import get_db
from core.response import success_response
from core.app_logging import get_logger
from schemas.churn_schema import ChurnRequest
from services import churn_services as churn_service

logger = get_logger(__name__)

router = APIRouter()


@router.post("/predict")
def predict(request_data: ChurnRequest, db: Session = Depends(get_db)):
    logger.info("Received churn prediction request")
    result = churn_service.predict_churn(db, request_data)
    return success_response(
        data=result,
        message="Prediction completed successfully",
        status_code=201,
    )


@router.get("")
def get_predictions(db: Session = Depends(get_db)):
    logger.info("Fetching all churn predictions")
    predictions = churn_service.get_all_predictions(db)
    return success_response(
        data=predictions,
        message=f"Retrieved {len(predictions)} churn prediction(s)",
    )