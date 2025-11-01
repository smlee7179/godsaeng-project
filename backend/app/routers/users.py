"""
사용자 라우터
"""
from fastapi import APIRouter, Depends
from app.utils.auth import get_current_user

router = APIRouter()

@router.get("/profile")
async def get_profile(current_user: dict = Depends(get_current_user)):
    """
    사용자 프로필 조회
    
    Args:
        current_user: 현재 사용자
        
    Returns:
        사용자 프로필 정보
    """
    return {
        "id": str(current_user["_id"]),
        "name": current_user["name"],
        "email": current_user["email"],
        "created_at": current_user.get("created_at")
    }

