from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


class ChurnRequest(BaseModel):
    account_length: int   = Field(..., ge=0,  description="Lama berlangganan (bulan)")
    number_vmail_messages: int   = Field(..., ge=0,  description="Jumlah pesan voicemail")
    total_day_minutes: float = Field(..., ge=0,  description="Total menit panggilan siang")
    total_day_calls: int   = Field(..., ge=0,  description="Total panggilan siang")
    total_day_charge:float = Field(..., ge=0,  description="Total biaya panggilan siang")
    total_eve_minutes: float = Field(..., ge=0,  description="Total menit panggilan malam")
    total_eve_calls: int   = Field(..., ge=0,  description="Total panggilan malam")
    total_eve_charge: float = Field(..., ge=0,  description="Total biaya panggilan malam")
    total_night_minutes:float = Field(..., ge=0,  description="Total menit panggilan tengah malam")
    total_night_calls:int   = Field(..., ge=0,  description="Total panggilan tengah malam")
    total_night_charge:float = Field(..., ge=0,  description="Total biaya panggilan tengah malam")
    total_intl_minutes:float = Field(..., ge=0,  description="Total menit panggilan internasional")
    total_intl_calls: int   = Field(..., ge=0,  description="Total panggilan internasional")
    total_intl_charge:float = Field(..., ge=0,  description="Total biaya panggilan internasional")
    customer_service_calls:int   = Field(..., ge=0,  description="Jumlah panggilan ke customer service")

    international_plan: str = Field(..., description="Paket internasional (Yes / No)")
    voice_mail_plan:str = Field(..., description="Paket voicemail (Yes / No)")

    model_config = {"json_schema_extra": {"example": {
        "account_length":         128,
        "number_vmail_messages":  25,
        "total_day_minutes":      265.1,
        "total_day_calls":        110,
        "total_day_charge":       45.07,
        "total_eve_minutes":      197.4,
        "total_eve_calls":        99,
        "total_eve_charge":       16.78,
        "total_night_minutes":    244.7,
        "total_night_calls":      91,
        "total_night_charge":     11.01,
        "total_intl_minutes":     10.0,
        "total_intl_calls":       3,
        "total_intl_charge":      2.70,
        "customer_service_calls": 1,
        "international_plan":     "No",
        "voice_mail_plan":        "Yes"
    }}}


# ── Hasil prediksi ──────────────────────────────────────────────
class PredictionResult(BaseModel):
    prediction_label:  str   = Field(..., description="Churn / Not Churn")
    churn_probability: float = Field(..., description="Probabilitas churn (0.0 - 1.0)")
    inference_time_ms: int   = Field(..., description="Waktu inferensi (ms)")

class ChurnPredictionResponse(BaseModel):
    id:                     int
    account_length:         int
    number_vmail_messages:  int
    total_day_minutes:      float
    total_day_calls:        int
    total_day_charge:       float
    total_eve_minutes:      float
    total_eve_calls:        int
    total_eve_charge:       float
    total_night_minutes:    float
    total_night_calls:      int
    total_night_charge:     float
    total_intl_minutes:     float
    total_intl_calls:       int
    total_intl_charge:      float
    customer_service_calls: int
    international_plan:     str
    voice_mail_plan:        str
    created_at:             Optional[datetime] = None
    prediction:             Optional[PredictionResult] = None

    model_config = {"from_attributes": True}