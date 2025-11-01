"""
애플리케이션 설정 관리
"""
import os
from typing import Optional
from pydantic_settings import BaseSettings
from pydantic import Field

# secrets.json 로드
def load_secrets():
    """secrets.json 파일 로드"""
    import json
    base_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))
    secret_file = os.path.join(base_dir, "backend", "config", "secrets.json")
    
    if not os.path.exists(secret_file):
        return {}
    
    with open(secret_file, "r", encoding="utf-8") as f:
        return json.load(f)

try:
    secrets = load_secrets()
except FileNotFoundError:
    secrets = {}

class Settings(BaseSettings):
    """애플리케이션 설정"""
    
    # MongoDB 설정
    mongodb_url: str = Field(
        default="mongodb://localhost:27017",
        description="MongoDB 연결 URL"
    )
    database_name: str = Field(
        default="godsaeng",
        description="데이터베이스 이름"
    )
    
    # JWT 설정
    secret_key: str = Field(
        default=secrets.get("JWT_SECRET_KEY", "your-secret-key-change-in-production"),
        description="JWT 시크릿 키"
    )
    algorithm: str = Field(
        default="HS256",
        description="JWT 알고리즘"
    )
    access_token_expire_minutes: int = Field(
        default=30,
        description="액세스 토큰 만료 시간(분)"
    )
    
    # AI 설정 (다양한 제공자 지원)
    openai_api_key: Optional[str] = Field(
        default=secrets.get("OPENAI_API_KEY", None),
        description="OpenAI API 키 (선택사항)"
    )
    
    huggingface_api_key: Optional[str] = Field(
        default=secrets.get("HUGGINGFACE_API_KEY", None),
        description="Hugging Face API 키 (선택사항, 무료 티어 있음)"
    )
    
    gemini_api_key: Optional[str] = Field(
        default=secrets.get("GEMINI_API_KEY", None),
        description="Google Gemini API 키 (선택사항, 무료 티어 있음)"
    )
    
    ai_provider: str = Field(
        default="huggingface",
        description="AI 제공자: huggingface, gemini, ollama, openai"
    )
    
    ollama_url: str = Field(
        default="http://localhost:11434",
        description="Ollama 서버 URL (로컬 실행 시)"
    )
    
    # 환경 설정
    environment: str = Field(
        default="development",
        description="실행 환경"
    )
    
    class Config:
        env_file = ".env"
        case_sensitive = False

# 전역 설정 인스턴스
_settings: Optional[Settings] = None

def get_settings() -> Settings:
    """설정 인스턴스 반환 (싱글톤 패턴)"""
    global _settings
    if _settings is None:
        _settings = Settings()
    return _settings
