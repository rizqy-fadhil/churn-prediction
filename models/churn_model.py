from sqlalchemy import Column, Integer, String, Float, Boolean, DateTime, Text, ForeignKey
from datetime import datetime
from sqlalchemy.orm import relationship
from core.databases import Base
import json

class ChurnPredictionInput(Base):
    __tablename__ = 'churn_prediction_input'

    id = Column(Integer, primary_key=True, index=True)
    account_length = Column(Integer)
    number_vmail_messages = Column(Integer)
    total_day_minutes = Column(Float)
    total_day_calls = Column(Integer)
    total_day_charge = Column(Float)
    total_eve_minutes = Column(Float)
    total_eve_calls = Column(Integer)
    total_eve_charge = Column(Float)
    total_night_minutes = Column(Float)
    total_night_calls = Column(Integer)
    total_night_charge = Column(Float)
    total_intl_minutes = Column(Float)
    total_intl_calls = Column(Integer)
    total_intl_charge = Column(Float)
    customer_service_calls  = Column(Integer)
    international_plan = Column(String)  
    voice_mail_plan = Column(String)

    created_at = Column(DateTime, default=datetime.utcnow)

    prediction = relationship("ChurnPredictionResult", back_populates="input_data", uselist=False)


class ChurnPredictionResult(Base):
    __tablename__ = 'churn_prediction_result'

    id = Column(Integer, primary_key=True, index=True)
    input_id = Column(Integer, ForeignKey('churn_prediction_input.id'))

    prediction_label = Column(String) 
    churn_probability = Column(Float)
    inference_time_ms = Column(Integer)
    created_at = Column(DateTime, default=datetime.utcnow)

    input_data = relationship("ChurnPredictionInput", back_populates="prediction")