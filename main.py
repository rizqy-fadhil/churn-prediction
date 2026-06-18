from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

import uvicorn
from core.databases import Base, engine
from core.app_logging import configure_logging, get_logger
from core.exceptions import register_exception_handlers
from routers.churn_routers import router as churn_router
from services.model_loader import load_model

configure_logging()
logger = get_logger(__name__)

Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Churn Prediction API",
    description="API for predicting customer churn using MLP deep learning model",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

register_exception_handlers(app)
app.include_router(churn_router, prefix="/api/churn", tags=["Churn"])

@app.on_event("startup")
def on_startup():
    logger.info("Starting up: loading ML model...")
    load_model()
    logger.info("Application ready")

@app.get("/")
def root():
    logger.info("Root endpoint accessed")
    return {"success": True, "message": "Welcome to the Churn Prediction API", "data": None}

if __name__ == "__main__":
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True, log_level="info")