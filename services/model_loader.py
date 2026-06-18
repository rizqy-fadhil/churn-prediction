import importlib.util
import os
from pathlib import Path

import joblib
import torch

from core.exceptions import ModelLoadError
from core.app_logging import get_logger

logger = get_logger(__name__)

BASE_DIR = Path(__file__).resolve().parent.parent
MODEL_DIR = BASE_DIR / "models" / "churn_model.pth"
PREPROCESSOR_DIR = BASE_DIR / "models" / "preprocessor.pkl"
MLP_MODEL_DIR = BASE_DIR / "deep-learning" / "model-setup" / "mlp.py"

class _ModelStore:
    """ Holds the loaded model and preprocessor. """
    model = None
    preprocessor = None
    device = None
    is_loaded = False

def _load_mlp_class():
    spec = importlib.util.spec_from_file_location("mlp", str(MLP_MODEL_DIR))
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module.MLP

def load_model():
    if _ModelStore.is_loaded:
        logger.info("Model already loaded, skipping reload.")
        return
    
    try:
        if not PREPROCESSOR_DIR.exists():
            raise ModelLoadError(f"Preprocessor file not found at {PREPROCESSOR_DIR}")
        
        _ModelStore.preprocessor = joblib.load(PREPROCESSOR_DIR)
        logger.info("Preprocessor loaded from %s", PREPROCESSOR_DIR)

        _ModelStore.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        logger.info("Using device: %s", _ModelStore.device)

        if not MODEL_DIR.exists():
            raise ModelLoadError(f"Model file not found at {MODEL_DIR}")
        
        MLP = _load_mlp_class()

        input_dim = _get_input_dim_from_preprocessor(_ModelStore.preprocessor)
        logger.info("Detected input dlm - dim: %d from preprocessor", input_dim)

        model = MLP(input_dim=input_dim)
        state_dict = torch.load(MODEL_DIR, map_location=_ModelStore.device, weights_only=True)
        model.load_state_dict(state_dict)
        model.to(_ModelStore.device)
        model.eval()

        _ModelStore.model = model
        _ModelStore.is_loaded = True
        logger.info("Model loaded successfully from %s", MODEL_DIR)

    except ModelLoadError:
        raise
    except Exception as ext:
        raise ModelLoadError(f"Failed to load model or preprocessor: {ext}")
    
def _get_input_dim_from_preprocessor(preprocessor) -> int:
    try:
        return len(preprocessor.get_feature_names_out())
    except AttributeError:
        pass

    try:
        total = 0
        for _, transformer, _ in preprocessor.transformers:
            total += len(transformer.get_feature_names_out())
        return total
    except AttributeError:
        pass

    state_dict = torch.load(MODEL_DIR, map_location="cpu", weights_only=True)
    for key, value in state_dict.items():
        if "weight" in key:
            return value.shape[1]
        
    raise ModelLoadError("Cannot determine input dimension from preprocessor or model weights.")

def get_model():
    if not _ModelStore.is_loaded:
        raise ModelLoadError("Model not loaded. Call load_model() first.")
    return _ModelStore.model

def get_device():
    return _ModelStore.device