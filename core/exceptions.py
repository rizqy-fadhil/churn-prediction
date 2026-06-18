from fastapi import Request
from core.response import error_response
from core.app_logging import get_logger

logger = get_logger(__name__)

class ModelLoadError(Exception):
    """Raised when the ML Model fails to load."""
    pass

class PreprocessingError(Exception):
    """Raised when input data cannot be processed."""
    pass

class PredictionError(Exception):
    """Raised when model interfence fails."""
    pass

def register_exception_handlers(app):
    @app.exception_handler(ModelLoadError)
    async def model_load_exception_handler(request: Request, exc: ModelLoadError):
        logger.error(f"Model Load Error: {exc}")
        return error_response(
            message="Model Loading Failed", 
            error=str(exc),
            status_code=503,
        )

    @app.exception_handler(PreprocessingError)
    async def preprocessing_exception_handler(request: Request, exc: PreprocessingError):
        logger.error(f"Preprocessing Error: {exc}")
        return error_response(
            message="Data preprocessing failed.", 
            error=str(exc),
            status_code=422
        )

    @app.exception_handler(PredictionError)
    async def prediction_exception_handler(request: Request, exc: PredictionError):
        logger.error(f"Prediction Error: {exc}")
        return error_response(
            message="Model prediction failed.",
            error=str(exc),
            status_code=500
        )
    
    @app.exception_handler(Exception)
    async def generic_exception_handler(request: Request, exc: Exception):
        logger.error(f"Unhandled Exception: {exc}")
        return error_response(
            message="An unexpected error occurred.",
            error=str(exc),
            status_code=500
        )