"""
MongoDB 데이터베이스 연결 및 설정
"""
import os
from motor.motor_asyncio import AsyncIOMotorClient
from app.config.settings import get_settings

settings = get_settings()

# MongoDB 클라이언트
client = None
db = None

async def init_db():
    """데이터베이스 초기화"""
    global client, db
    mongodb_url = os.getenv("MONGODB_URL", settings.mongodb_url)
    
    # Render 환경에서 PORT 환경 변수 확인
    if not mongodb_url:
        raise ValueError("MONGODB_URL 환경 변수가 설정되지 않았습니다.")
    
    try:
        # MongoDB Atlas SSL 연결 설정
        # SSL 옵션을 명시적으로 설정하여 TLS 오류 방지
        import ssl
        
        # 연결 문자열에 이미 SSL 옵션이 있으면 그대로 사용
        # 없으면 SSL 설정을 추가
        ssl_context = ssl.create_default_context()
        ssl_context.check_hostname = False
        ssl_context.verify_mode = ssl.CERT_NONE
        
        # AsyncIOMotorClient에 SSL 설정 전달
        # 연결 문자열에 tls=true가 포함되어 있으면 자동으로 SSL 사용
        # 명시적 SSL 파라미터는 연결 문자열 옵션으로 처리
        if "tls=" not in mongodb_url and "ssl=" not in mongodb_url:
            # 연결 문자열에 SSL 옵션 추가
            separator = "&" if "?" in mongodb_url else "?"
            mongodb_url = f"{mongodb_url}{separator}tls=true&tlsAllowInvalidCertificates=true"
        
        client = AsyncIOMotorClient(mongodb_url)
        db = client[settings.database_name]
        
        # 연결 테스트
        await client.admin.command('ping')
        
        # 인덱스 생성
        await db.users.create_index("email", unique=True)
        await db.daily_logs.create_index([("user_id", 1), ("timestamp", -1)])
        await db.ai_reports.create_index([("user_id", 1), ("date", -1)])
        
        print(f"✅ MongoDB 연결 성공: {settings.database_name}")
    except Exception as e:
        print(f"❌ MongoDB 연결 실패: {str(e)}")
        raise

async def close_db():
    """데이터베이스 연결 종료"""
    global client
    if client:
        client.close()
        client = None

def get_database():
    """데이터베이스 인스턴스 반환"""
    return db

