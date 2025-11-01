"""
라이프 기록 라우터
"""
from datetime import datetime
from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, status, Query
from app.models.log import DailyLogCreate, DailyLogUpdate, DailyLog
from app.database import get_database
from app.utils.auth import get_current_user
from bson import ObjectId
from datetime import date, timedelta

router = APIRouter()

@router.post("", status_code=status.HTTP_201_CREATED)
async def create_log(
    log_data: DailyLogCreate,
    current_user: dict = Depends(get_current_user)
):
    """
    새로운 라이프 기록 생성
    
    Args:
        log_data: 기록 데이터
        current_user: 현재 사용자
        
    Returns:
        생성된 기록 정보
    """
    db = get_database()
    
    log_doc = {
        "user_id": ObjectId(current_user["_id"]),
        "activity": log_data.activity,
        "photo_url": log_data.photo_url,
        "tags": log_data.tags or [],
        "mood": log_data.mood,
        "location": log_data.location,
        "timestamp": datetime.utcnow(),
        "created_at": datetime.utcnow(),
        "updated_at": datetime.utcnow()
    }
    
    result = await db.daily_logs.insert_one(log_doc)
    log_doc["_id"] = result.inserted_id
    
    # 응답 형식 변환
    log_doc["id"] = str(log_doc["_id"])
    log_doc["user_id"] = str(log_doc["user_id"])
    del log_doc["_id"]
    
    return log_doc

@router.get("", response_model=List[dict])
async def get_logs(
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    start_date: Optional[date] = Query(None),
    end_date: Optional[date] = Query(None),
    current_user: dict = Depends(get_current_user)
):
    """
    라이프 기록 목록 조회
    
    Args:
        skip: 건너뛸 개수
        limit: 가져올 개수
        start_date: 시작 날짜
        end_date: 종료 날짜
        current_user: 현재 사용자
        
    Returns:
        기록 목록
    """
    db = get_database()
    
    # 쿼리 조건 구성
    query = {"user_id": ObjectId(current_user["_id"])}
    
    if start_date or end_date:
        date_filter = {}
        if start_date:
            date_filter["$gte"] = datetime.combine(start_date, datetime.min.time())
        if end_date:
            date_filter["$lte"] = datetime.combine(end_date, datetime.max.time())
        query["timestamp"] = date_filter
    
    # 기록 조회
    cursor = db.daily_logs.find(query).sort("timestamp", -1).skip(skip).limit(limit)
    logs = await cursor.to_list(length=limit)
    
    # 응답 형식 변환
    result = []
    for log in logs:
        log["id"] = str(log["_id"])
        log["user_id"] = str(log["user_id"])
        del log["_id"]
        log.pop("hashed_password", None)  # 혹시 모를 보안
        result.append(log)
    
    return result

@router.get("/today")
async def get_today_logs(current_user: dict = Depends(get_current_user)):
    """
    오늘의 기록 조회
    
    Args:
        current_user: 현재 사용자
        
    Returns:
        오늘의 기록 목록
    """
    today = date.today()
    return await get_logs(
        start_date=today,
        end_date=today,
        current_user=current_user
    )

@router.get("/{log_id}")
async def get_log(
    log_id: str,
    current_user: dict = Depends(get_current_user)
):
    """
    특정 기록 조회
    
    Args:
        log_id: 기록 ID
        current_user: 현재 사용자
        
    Returns:
        기록 정보
    """
    db = get_database()
    
    try:
        log_id_obj = ObjectId(log_id)
    except:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="유효하지 않은 기록 ID입니다."
        )
    
    log = await db.daily_logs.find_one({
        "_id": log_id_obj,
        "user_id": ObjectId(current_user["_id"])
    })
    
    if not log:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="기록을 찾을 수 없습니다."
        )
    
    log["id"] = str(log["_id"])
    log["user_id"] = str(log["user_id"])
    del log["_id"]
    
    return log

@router.put("/{log_id}")
async def update_log(
    log_id: str,
    log_update: DailyLogUpdate,
    current_user: dict = Depends(get_current_user)
):
    """
    기록 수정
    
    Args:
        log_id: 기록 ID
        log_update: 수정할 데이터
        current_user: 현재 사용자
        
    Returns:
        수정된 기록 정보
    """
    db = get_database()
    
    try:
        log_id_obj = ObjectId(log_id)
    except:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="유효하지 않은 기록 ID입니다."
        )
    
    # 업데이트할 데이터 구성
    update_data = {"updated_at": datetime.utcnow()}
    if log_update.activity is not None:
        update_data["activity"] = log_update.activity
    if log_update.photo_url is not None:
        update_data["photo_url"] = log_update.photo_url
    if log_update.tags is not None:
        update_data["tags"] = log_update.tags
    if log_update.mood is not None:
        update_data["mood"] = log_update.mood
    if log_update.location is not None:
        update_data["location"] = log_update.location
    
    result = await db.daily_logs.update_one(
        {"_id": log_id_obj, "user_id": ObjectId(current_user["_id"])},
        {"$set": update_data}
    )
    
    if result.matched_count == 0:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="기록을 찾을 수 없습니다."
        )
    
    # 수정된 기록 반환
    return await get_log(log_id, current_user)

@router.delete("/{log_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_log(
    log_id: str,
    current_user: dict = Depends(get_current_user)
):
    """
    기록 삭제
    
    Args:
        log_id: 기록 ID
        current_user: 현재 사용자
    """
    db = get_database()
    
    try:
        log_id_obj = ObjectId(log_id)
    except:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="유효하지 않은 기록 ID입니다."
        )
    
    result = await db.daily_logs.delete_one({
        "_id": log_id_obj,
        "user_id": ObjectId(current_user["_id"])
    })
    
    if result.deleted_count == 0:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="기록을 찾을 수 없습니다."
        )
    
    return None

