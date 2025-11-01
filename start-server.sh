#!/bin/bash

# GODSAENG PROJECT 서버 시작 스크립트 (인터넷 접근 가능)

set -e

echo "🚀 GODSAENG 서버 시작 중..."

# .env 파일 확인
if [ ! -f .env ]; then
    echo "📝 .env 파일 생성 중..."
    cp .env.example .env
fi

# secrets.json 확인
if [ ! -f backend/config/secrets.json ]; then
    echo "📝 secrets.json 파일 생성 중..."
    mkdir -p backend/config
    echo '{"JWT_SECRET_KEY": "'$(openssl rand -hex 32)'", "HUGGINGFACE_API_KEY": "", "GEMINI_API_KEY": ""}' > backend/config/secrets.json
fi

# Docker 및 Docker Compose 확인
if ! command -v docker &> /dev/null; then
    echo "❌ Docker가 설치되어 있지 않습니다."
    echo "Docker 설치: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose가 설치되어 있지 않습니다."
    exit 1
fi

# 기존 컨테이너 중지 및 제거
echo "🧹 기존 컨테이너 정리 중..."
docker-compose down 2>/dev/null || true

# 서비스 시작
echo "🐳 Docker 컨테이너 시작 중..."
docker-compose up -d --build

# 서비스 시작 대기
echo "⏳ 서비스 시작 대기 중..."
sleep 15

# 헬스 체크
echo "🔍 서비스 상태 확인 중..."
if curl -s http://localhost:8000/ > /dev/null 2>&1; then
    echo ""
    echo "✅ 서버가 성공적으로 시작되었습니다!"
    echo ""
    echo "📝 로컬 접속 정보:"
    echo "   - Frontend: http://localhost"
    echo "   - Backend API: http://localhost:8000"
    echo "   - API Docs: http://localhost:8000/docs"
    echo ""
    
    # 네트워크 IP 주소 확인
    if [[ "$OSTYPE" == "darwin"* ]]; then
        LOCAL_IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "IP를 찾을 수 없습니다")
    else
        LOCAL_IP=$(hostname -I | awk '{print $1}')
    fi
    
    if [ "$LOCAL_IP" != "IP를 찾을 수 없습니다" ]; then
        echo "📡 로컬 네트워크 접속 정보:"
        echo "   - Frontend: http://$LOCAL_IP"
        echo "   - Backend API: http://$LOCAL_IP:8000"
        echo ""
    fi
    
    echo "🌐 인터넷에서 접속하려면 ngrok을 사용하세요:"
    echo "   1. ngrok 설치: https://ngrok.com/download"
    echo "   2. ngrok 실행: ngrok http 80"
    echo ""
    echo "📊 서비스 로그 확인: docker-compose logs -f"
    echo "🛑 서비스 중지: docker-compose down"
else
    echo "❌ 서버 시작에 문제가 있습니다. 로그를 확인하세요:"
    echo "   docker-compose logs"
    exit 1
fi

