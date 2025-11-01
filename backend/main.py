"""
GODSAENG PROJECT - FastAPI 백엔드 메인 애플리케이션
AI 기반 라이프 트래킹 웹 앱
"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from contextlib import asynccontextmanager
import os

from app.routers import auth, logs, ai_reports, users
from app.database import init_db

@asynccontextmanager
async def lifespan(app: FastAPI):
    """애플리케이션 라이프사이클 관리"""
    # 시작 시
    await init_db()
    yield
    # 종료 시
    from app.database import close_db
    await close_db()

app = FastAPI(
    title="GODSAENG API",
    description="AI 기반 라이프 트래킹 웹 앱 API",
    version="1.0.0",
    lifespan=lifespan
)

# CORS 설정
# 개발 환경과 프로덕션 환경 모두 지원

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

@app.get("/")
async def root():
    """루트 엔드포인트 - 헬스체크"""
    return {
        "message": "GODSAENG API 서버가 실행 중입니다.",
        "status": "healthy",
        "version": "1.0.0"
    }

@app.get("/health")
async def health_check():
    """헬스체크 엔드포인트"""
    try:
        from app.database import get_database
        db = get_database()
        if db:
            # 간단한 데이터베이스 연결 확인
            await db.command('ping')
            return {
                "status": "healthy",
                "database": "connected",
                "version": "1.0.0"
            }
        else:
            return {
                "status": "degraded",
                "database": "not_connected",
                "version": "1.0.0"
            }
    except Exception as e:
        return {
            "status": "unhealthy",
            "database": "error",
            "error": str(e),
            "version": "1.0.0"
        }

@app.get("/status")
async def system_status():
    """시스템 상태 상세 확인 엔드포인트"""
    import os
    from datetime import datetime
    
    status_info = {
        "timestamp": datetime.utcnow().isoformat(),
        "version": "1.0.0",
        "components": {}
    }
    
    # 데이터베이스 상태 확인
    try:
        from app.database import get_database
        db = get_database()
        if db:
            await db.command('ping')
            # 데이터베이스 통계
            db_stats = await db.command('dbStats')
            status_info["components"]["database"] = {
                "status": "connected",
                "name": db.name,
                "collections": len(await db.list_collection_names())
            }
        else:
            status_info["components"]["database"] = {
                "status": "not_connected",
                "error": "Database client not initialized"
            }
    except Exception as e:
        status_info["components"]["database"] = {
            "status": "error",
            "error": str(e)
        }
    
    # 환경 변수 확인 (민감한 정보 제외)
    env_vars = {
        "MONGODB_URL": "설정됨" if os.getenv("MONGODB_URL") else "설정 안됨",
        "DATABASE_NAME": os.getenv("DATABASE_NAME", "godsaeng"),
        "AI_PROVIDER": os.getenv("AI_PROVIDER", "huggingface"),
        "HUGGINGFACE_API_KEY": "설정됨" if os.getenv("HUGGINGFACE_API_KEY") else "설정 안됨",
        "GEMINI_API_KEY": "설정됨" if os.getenv("GEMINI_API_KEY") else "설정 안됨",
        "FRONTEND_URL": os.getenv("FRONTEND_URL", "설정 안됨"),
    }
    status_info["components"]["environment"] = env_vars
    
    # 전체 상태 결정
    all_healthy = all(
        comp.get("status") == "connected" or comp.get("status") == "healthy"
        for comp in status_info["components"].values()
        if isinstance(comp, dict) and "status" in comp
    )
    
    status_info["overall_status"] = "healthy" if all_healthy else "degraded"
    
    return status_info

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
