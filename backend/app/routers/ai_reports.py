"""
AI 분석 리포트 라우터
"""
from datetime import date, datetime
from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, status, Query
from app.models.ai_report import AIReportCreate, AIReport
from app.database import get_database
from app.utils.auth import get_current_user
from app.services.ai_service import ai_service
from app.models.log import DailyLog
from bson import ObjectId

router = APIRouter()

@router.post("/analyze", status_code=status.HTTP_201_CREATED)
async def create_ai_report(
    report_data: AIReportCreate,
    current_user: dict = Depends(get_current_user)
):
    """
    특정 날짜의 기록들을 AI로 분석하여 리포트 생성
    
    Args:
        report_data: 분석 요청 데이터 (날짜)
        current_user: 현재 사용자
        
    Returns:
        AI 분석 리포트
    """
    db = get_database()
    
    # 해당 날짜의 기록들 조회
    start_datetime = datetime.combine(report_data.date, datetime.min.time())
    end_datetime = datetime.combine(report_data.date, datetime.max.time())
    
    logs_cursor = db.daily_logs.find({
        "user_id": ObjectId(current_user["_id"]),
        "timestamp": {
            "$gte": start_datetime,
            "$lte": end_datetime
        }
    }).sort("timestamp", 1)
    
    logs_list = await logs_cursor.to_list(length=100)
    
    # DailyLog 모델로 변환
    logs = []
    for log_doc in logs_list:
        log = DailyLog(
            id=log_doc["_id"],
            user_id=log_doc["user_id"],
            activity=log_doc.get("activity", ""),
            photo_url=log_doc.get("photo_url"),
            tags=log_doc.get("tags", []),
            mood=log_doc.get("mood"),
            location=log_doc.get("location"),
            timestamp=log_doc.get("timestamp"),
            created_at=log_doc.get("created_at"),
            updated_at=log_doc.get("updated_at")
        )
        logs.append(log)
    
    # AI 분석 수행
    ai_result = await ai_service.analyze_daily_logs(logs, report_data.date)
    
    # 리포트 저장
    report_doc = {
        "user_id": ObjectId(current_user["_id"]),
        "date": report_data.date,
        "summary": ai_result["summary"],
        "feedback": ai_result.get("feedback", ""),
        "emotions": ai_result.get("emotions", []),
        "insights": ai_result.get("insights", []),
        "recommendations": ai_result.get("recommendations", []),
        "created_at": datetime.utcnow()
    }
    
    # 기존 리포트가 있으면 업데이트, 없으면 생성
    existing = await db.ai_reports.find_one({
        "user_id": ObjectId(current_user["_id"]),
        "date": report_data.date
    })
    
    if existing:
        await db.ai_reports.update_one(
            {"_id": existing["_id"]},
            {"$set": report_doc}
        )
        report_doc["_id"] = existing["_id"]
    else:
        result = await db.ai_reports.insert_one(report_doc)
        report_doc["_id"] = result.inserted_id
    
    # 응답 형식 변환
    report_doc["id"] = str(report_doc["_id"])
    report_doc["user_id"] = str(report_doc["user_id"])
    del report_doc["_id"]
    
    return report_doc

@router.get("/report")
async def get_ai_report(
    target_date: date = Query(..., description="조회할 날짜"),
    current_user: dict = Depends(get_current_user)
):
    """
    특정 날짜의 AI 리포트 조회
    
    Args:
        target_date: 조회할 날짜
        current_user: 현재 사용자
        
    Returns:
        AI 리포트 정보
    """
    db = get_database()
    
    report = await db.ai_reports.find_one({
        "user_id": ObjectId(current_user["_id"]),
        "date": target_date
    })
    
    if not report:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="해당 날짜의 AI 리포트가 없습니다. 먼저 분석을 실행해주세요."
        )
    
    report["id"] = str(report["_id"])
    report["user_id"] = str(report["user_id"])
    del report["_id"]
    
    return report

@router.get("/reports")
async def get_ai_reports(
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    current_user: dict = Depends(get_current_user)
):
    """
    AI 리포트 목록 조회
    
    Args:
        skip: 건너뛸 개수
        limit: 가져올 개수
        current_user: 현재 사용자
        
    Returns:
        AI 리포트 목록
    """
    db = get_database()
    
    cursor = db.ai_reports.find(
        {"user_id": ObjectId(current_user["_id"])}
    ).sort("date", -1).skip(skip).limit(limit)
    
    reports = await cursor.to_list(length=limit)
    
    result = []
    for report in reports:
        report["id"] = str(report["_id"])
        report["user_id"] = str(report["user_id"])
        del report["_id"]
        result.append(report)
    
    return result

