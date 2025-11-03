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
        # MongoDB Atlas 연결 설정
        # 순차적 해결 방법 적용
        
        # 방법 1: 최소 설정으로 시작 (가장 단순)
        # mongodb+srv://는 기본적으로 TLS를 사용하므로 추가 설정 불필요
        
        # 연결 문자열에 tlsAllowInvalidCertificates 추가 시도 (개발 환경용)
        if "tlsAllowInvalidCertificates" not in mongodb_url and "mongodb+srv://" in mongodb_url:
            separator = "&" if "?" in mongodb_url else "?"
            mongodb_url = f"{mongodb_url}{separator}tlsAllowInvalidCertificates=true"
        
        # 최소 설정으로 클라이언트 생성
        # 타임아웃만 설정하고, SSL은 연결 문자열에 의존
        try:
            client = AsyncIOMotorClient(
                mongodb_url,
                serverSelectionTimeoutMS=30000,
                connectTimeoutMS=20000
            )
        except Exception as e1:
            # 첫 번째 시도 실패 시, tlsAllowInvalidCertificates 파라미터 추가
            print(f"⚠️ 첫 번째 연결 시도 실패: {str(e1)[:200]}")
            print("⚠️ tlsAllowInvalidCertificates 파라미터로 재시도...")
            
            try:
                client = AsyncIOMotorClient(
                    mongodb_url,
                    tlsAllowInvalidCertificates=True,
                    serverSelectionTimeoutMS=30000,
                    connectTimeoutMS=20000
                )
            except Exception as e2:
                # 두 번째 시도도 실패 시, 최소 설정으로 재시도
                print(f"⚠️ 두 번째 연결 시도 실패: {str(e2)[:200]}")
                print("⚠️ 최소 설정으로 재시도...")
                
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

