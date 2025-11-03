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
        # Render 환경에서 SSL 핸드셰이크 문제 해결을 위한 명시적 설정
        import ssl
        
        # PyMongo/Motor가 지원하는 SSL 파라미터 사용
        # ssl_context는 지원하지 않으므로 ssl_cert_reqs 사용
        
        # 연결 문자열에 TLS 옵션 추가 (이미 있으면 유지)
        if "tlsAllowInvalidCertificates" not in mongodb_url:
            separator = "&" if "?" in mongodb_url else "?"
            mongodb_url = f"{mongodb_url}{separator}tlsAllowInvalidCertificates=true"
        
        # mongodb+srv:// 프로토콜을 사용하는 경우
        # PyMongo/Motor가 지원하는 SSL 파라미터 사용
        if mongodb_url.startswith("mongodb+srv://"):
            # mongodb+srv://는 기본적으로 TLS 사용
            # ssl_cert_reqs를 CERT_NONE으로 설정하여 인증서 검증 우회
            client = AsyncIOMotorClient(
                mongodb_url,
                tls=True,
                tlsAllowInvalidCertificates=True,
                serverSelectionTimeoutMS=30000,
                connectTimeoutMS=20000
            )
        else:
            # mongodb:// 프로토콜 사용 시
            # ssl_cert_reqs 파라미터 사용 (tls=False일 때)
            client = AsyncIOMotorClient(
                mongodb_url,
                tls=True,
                tlsAllowInvalidCertificates=True,
                serverSelectionTimeoutMS=30000,
                connectTimeoutMS=20000
            )
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

