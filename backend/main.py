"""
GODSAENG PROJECT - FastAPI 백엔드 메인 애플리케이션
AI 기반 라이프 트래킹 웹 앱
"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.routers import auth, logs, ai_reports, users
from app.database import init_db

app = FastAPI(
    title="GODSAENG API",
    description="AI 기반 라이프 트래킹 웹 앱 API",
    version="1.0.0"
)

# CORS 설정
# 개발 환경과 프로덕션 환경 모두 지원
import os

# Render 환경 변수에서 프론트엔드 URL 가져오기
frontend_url = os.getenv("FRONTEND_URL", "https://godsaeng-frontend.onrender.com")

allowed_origins = [
    "http://localhost:3000",
    "http://localhost:5173",
    frontend_url,
]

# Render 도메인 패턴 지원 (동적 추가)
if "onrender.com" in frontend_url:
    allowed_origins.append(frontend_url.replace(".onrender.com", "") + ".onrender.com")

app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 라우터 등록
app.include_router(auth.router, prefix="/api/auth", tags=["인증"])
app.include_router(users.router, prefix="/api/users", tags=["사용자"])
app.include_router(logs.router, prefix="/api/logs", tags=["라이프 기록"])
app.include_router(ai_reports.router, prefix="/api/ai", tags=["AI 분석"])

@app.on_event("startup")
async def startup_event():
    """애플리케이션 시작 시 데이터베이스 초기화"""
    await init_db()

@app.get("/")
async def root():
    """루트 엔드포인트"""
    return {"message": "GODSAENG API 서버가 실행 중입니다."}

@app.get("/config")
async def get_config():
    """프론트엔드 설정 정보 반환"""
    return {
        "api_version": "1.0.0",
        "features": {
            "ai_analysis": True,
            "daily_logs": True,
            "user_auth": True
        }
    }

@app.exception_handler(Exception)
async def global_exception_handler(request, exc):
    """전역 예외 처리"""
    return JSONResponse(
        status_code=500,
        content={"message": "서버 내부 오류가 발생했습니다.", "error": str(exc)}
    )

