"""
AI 분석 리포트 모델
"""
from datetime import datetime, date
from typing import Optional, List
from pydantic import BaseModel, Field
from bson import ObjectId

class AIReportBase(BaseModel):
    """AI 리포트 기본 모델"""
    summary: str
    feedback: Optional[str] = None
    emotions: Optional[List[str]] = None
    insights: Optional[List[str]] = None
    recommendations: Optional[List[str]] = None

class AIReportCreate(BaseModel):
    """AI 리포트 생성 모델"""
    date: date

class AIReport(AIReportBase):
    """AI 리포트 응답 모델"""
    id: Optional[str] = None
    user_id: Optional[str] = None
    date: Optional[date] = None
    created_at: Optional[datetime] = None
    
    class Config:
        arbitrary_types_allowed = True
        json_encoders = {ObjectId: str}
