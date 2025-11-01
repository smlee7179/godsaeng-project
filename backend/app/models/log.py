"""
라이프 기록 모델
"""
from datetime import datetime
from typing import Optional, List
from pydantic import BaseModel, Field
from bson import ObjectId

class DailyLogBase(BaseModel):
    """라이프 기록 기본 모델"""
    activity: str = Field(..., description="활동 내용")
    photo_url: Optional[str] = Field(None, description="사진 URL")
    tags: Optional[List[str]] = Field(default_factory=list, description="태그 목록")
    mood: Optional[str] = Field(None, description="감정 상태")
    location: Optional[str] = Field(None, description="위치")

class DailyLogCreate(DailyLogBase):
    """라이프 기록 생성 모델"""
    pass

class DailyLogUpdate(BaseModel):
    """라이프 기록 수정 모델"""
    activity: Optional[str] = None
    photo_url: Optional[str] = None
    tags: Optional[List[str]] = None
    mood: Optional[str] = None
    location: Optional[str] = None

class DailyLog(DailyLogBase):
    """라이프 기록 응답 모델"""
    id: Optional[str] = None
    user_id: Optional[str] = None
    timestamp: Optional[datetime] = None
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None
    
    class Config:
        arbitrary_types_allowed = True
        json_encoders = {ObjectId: str}

