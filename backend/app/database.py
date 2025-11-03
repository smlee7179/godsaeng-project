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
        
        # SSL 컨텍스트 생성 - 인증서 검증 우회 (개발 환경용)
        # Python 버전 호환성을 위한 SSL 컨텍스트 생성
        try:
            # Python 3.7+ (PROTOCOL_TLS_CLIENT)
            ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
        except AttributeError:
            try:
                # Python 3.6 (PROTOCOL_TLS)
                ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLS)
            except AttributeError:
                # 이전 버전 (PROTOCOL_SSLv23)
                ssl_context = ssl.SSLContext(ssl.PROTOCOL_SSLv23)
        
        ssl_context.check_hostname = False
        ssl_context.verify_mode = ssl.CERT_NONE
        
        # mongodb+srv://는 이미 TLS를 사용하므로 추가 설정은 선택적
        # 하지만 Render 환경에서는 SSL 컨텍스트를 명시적으로 전달해야 함
        
        # 연결 옵션 설정
        client_options = {
            "serverSelectionTimeoutMS": 30000,
            "connectTimeoutMS": 20000,
            "ssl_context": ssl_context,
        }
        
        # mongodb+srv:// 프로토콜을 사용하는 경우
        # SSL 컨텍스트를 직접 전달하여 SSL 핸드셰이크 문제 해결
        if mongodb_url.startswith("mongodb+srv://"):
            # mongodb+srv://는 기본적으로 TLS 사용
            # SSL 컨텍스트를 명시적으로 전달
            client = AsyncIOMotorClient(
                mongodb_url,
                tls=True,
                ssl_context=ssl_context,
                serverSelectionTimeoutMS=30000,
                connectTimeoutMS=20000
            )
        else:
            # mongodb:// 프로토콜 사용 시
            client = AsyncIOMotorClient(
                mongodb_url,
                tls=True,
                ssl_context=ssl_context,
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

