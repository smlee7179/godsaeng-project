"""
인증 라우터
"""
from datetime import timedelta
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from app.models.user import UserCreate, UserLogin
from app.database import get_database
from app.utils.auth import (
    verify_password,
    get_password_hash,
    create_access_token,
    get_current_user
)
from app.config.settings import get_settings
from bson import ObjectId
from datetime import datetime

router = APIRouter()
settings = get_settings()

@router.post("/register", status_code=status.HTTP_201_CREATED)
async def register(user_data: UserCreate):
    """
    사용자 회원가입
    
    Args:
        user_data: 회원가입 정보
        
    Returns:
        생성된 사용자 정보
    """
    db = get_database()
    
    # 이메일 중복 확인
    existing_user = await db.users.find_one({"email": user_data.email})
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="이미 등록된 이메일입니다."
        )
    
    # 비밀번호 해시화
    hashed_password = get_password_hash(user_data.password)
    
    # 사용자 생성
    user_doc = {
        "name": user_data.name,
        "email": user_data.email,
        "hashed_password": hashed_password,
        "created_at": datetime.utcnow()
    }
    
    result = await db.users.insert_one(user_doc)
    user_doc["_id"] = result.inserted_id
    
    # 응답 반환 (비밀번호 제외)
    user_doc.pop("hashed_password", None)
    user_doc["id"] = str(user_doc["_id"])
    del user_doc["_id"]
    
    return {
        "message": "회원가입이 완료되었습니다.",
        "user": user_doc
    }

@router.post("/login")
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    """
    사용자 로그인 (OAuth2 형식)
    
    Args:
        form_data: 로그인 폼 데이터 (username=email, password)
        
    Returns:
        JWT 액세스 토큰
    """
    db = get_database()
    
    # 사용자 찾기
    user = await db.users.find_one({"email": form_data.username})
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="이메일 또는 비밀번호가 올바르지 않습니다.",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # 비밀번호 확인
    if not verify_password(form_data.password, user["hashed_password"]):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="이메일 또는 비밀번호가 올바르지 않습니다.",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # JWT 토큰 생성
    access_token_expires = timedelta(minutes=settings.access_token_expire_minutes)
    access_token = create_access_token(
        data={"sub": str(user["_id"])},
        expires_delta=access_token_expires
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": {
            "id": str(user["_id"]),
            "name": user["name"],
            "email": user["email"]
        }
    }

@router.post("/login-json")
async def login_json(user_data: UserLogin):
    """
    사용자 로그인 (JSON 형식)
    
    Args:
        user_data: 로그인 정보
        
    Returns:
        JWT 액세스 토큰
    """
    db = get_database()
    
    # 사용자 찾기
    user = await db.users.find_one({"email": user_data.email})
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="이메일 또는 비밀번호가 올바르지 않습니다.",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # 비밀번호 확인
    if not verify_password(user_data.password, user["hashed_password"]):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="이메일 또는 비밀번호가 올바르지 않습니다.",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # JWT 토큰 생성
    access_token_expires = timedelta(minutes=settings.access_token_expire_minutes)
    access_token = create_access_token(
        data={"sub": str(user["_id"])},
        expires_delta=access_token_expires
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": {
            "id": str(user["_id"]),
            "name": user["name"],
            "email": user["email"]
        }
    }

@router.get("/me")
async def get_me(current_user: dict = Depends(get_current_user)):
    """
    현재 로그인한 사용자 정보 조회
    
    Args:
        current_user: 현재 사용자 (의존성 주입)
        
    Returns:
        사용자 정보
    """
    return {
        "id": str(current_user["_id"]),
        "name": current_user["name"],
        "email": current_user["email"],
        "created_at": current_user.get("created_at")
    }

