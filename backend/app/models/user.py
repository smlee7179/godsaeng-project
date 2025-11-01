"""
사용자 모델
"""
from datetime import datetime
from typing import Optional
from pydantic import BaseModel, EmailStr
from bson import ObjectId


class UserBase(BaseModel):
    """사용자 기본 모델"""
    name: str
    email: EmailStr

class UserCreate(UserBase):
    """사용자 생성 모델"""
    password: str

class UserLogin(BaseModel):
    """사용자 로그인 모델"""
    email: EmailStr
    password: str

class User(UserBase):
    """사용자 응답 모델"""
    id: Optional[str] = None
    created_at: Optional[datetime] = None
    hashed_password: Optional[str] = None
    
    class Config:
        arbitrary_types_allowed = True
        json_encoders = {ObjectId: str}

class UserInDB(User):
    """데이터베이스 내 사용자 모델"""
    pass

