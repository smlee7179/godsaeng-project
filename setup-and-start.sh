#!/bin/bash

# GODSAENG 프로젝트 완전 설정 및 시작 스크립트

set -e

echo "🚀 GODSAENG 프로젝트 설정 및 시작"
echo ""

cd "$(dirname "$0")"

# 1. MongoDB 설정
echo "📦 MongoDB 설정 중..."

# Docker로 MongoDB 실행 시도
if command -v docker &> /dev/null; then
    if docker ps -a | grep -q mongodb; then
        echo "   MongoDB 컨테이너 발견 - 시작 중..."
        docker start mongodb 2>/dev/null || true
        sleep 3
        if docker ps | grep -q mongodb; then
            echo "   ✅ MongoDB 실행 중 (Docker)"
            MONGODB_URL="mongodb://localhost:27017"
            MONGODB_READY=true
        fi
    elif ! docker ps | grep -q mongodb; then
        echo "   Docker로 MongoDB 컨테이너 생성 시도 중..."
        docker run -d -p 27017:27017 --name mongodb mongo:7.0 2>/dev/null && sleep 5 && \
        docker ps | grep -q mongodb && echo "   ✅ MongoDB 실행 중 (Docker)" && \
        MONGODB_URL="mongodb://localhost:27017" && MONGODB_READY=true || true
    fi
fi

# MongoDB가 준비되지 않으면 경고
if [ -z "$MONGODB_READY" ]; then
    echo "   ⚠️  MongoDB가 실행 중이지 않습니다."
    echo ""
    echo "   MongoDB를 시작하려면 다음 중 하나를 실행하세요:"
    echo ""
    echo "   1. Docker 사용 (권장):"
    echo "      docker run -d -p 27017:27017 --name mongodb mongo:7.0"
    echo ""
    echo "   2. 로컬 설치:"
    echo "      brew tap mongodb/brew"
    echo "      brew install mongodb-community"
    echo "      brew services start mongodb-community"
    echo ""
    read -p "   계속하시겠습니까? (MongoDB 없이는 작동하지 않습니다) [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 2. 환경 설정
echo ""
echo "⚙️  환경 설정 중..."

if [ ! -f .env ]; then
    echo "   .env 파일 생성 중..."
    cp .env.example .env
fi

if [ ! -f backend/config/secrets.json ]; then
    echo "   secrets.json 파일 생성 중..."
    mkdir -p backend/config
    JWT_KEY=$(python3 -c "import secrets; print(secrets.token_hex(32))" 2>/dev/null || openssl rand -hex 32)
    echo "{\"JWT_SECRET_KEY\": \"$JWT_KEY\", \"HUGGINGFACE_API_KEY\": \"\", \"GEMINI_API_KEY\": \"\"}" > backend/config/secrets.json
fi

# 3. 백엔드 설정
echo ""
echo "🔧 백엔드 설정 중..."
cd backend

if [ ! -d "venv" ]; then
    echo "   Python 가상 환경 생성 중..."
    python3 -m venv venv
fi

echo "   가상 환경 활성화..."
source venv/bin/activate

if [ ! -f "venv/.installed" ]; then
    echo "   Python 의존성 설치 중... (시간이 걸릴 수 있습니다)"
    pip install --upgrade pip -q
    pip install -r requirements.txt -q
    touch venv/.installed
fi

# 4. 프론트엔드 설정
echo ""
echo "🎨 프론트엔드 설정 중..."
cd ../frontend

if [ ! -d "node_modules" ]; then
    echo "   Node.js 의존성 설치 중... (시간이 걸릴 수 있습니다)"
    npm install --silent
fi

# 5. 서버 시작
echo ""
echo "🚀 서버 시작 중..."
echo ""

cd ../backend
source venv/bin/activate
export MONGODB_URL=${MONGODB_URL:-mongodb://localhost:27017}
export DATABASE_NAME=godsaeng
export AI_PROVIDER=huggingface

echo "   백엔드 서버 시작..."
uvicorn main:app --host 0.0.0.0 --port 8000 > ../backend.log 2>&1 &
BACKEND_PID=$!
echo "   ✅ 백엔드 시작됨 (PID: $BACKEND_PID)"

sleep 3

cd ../frontend
export VITE_API_BASE_URL=http://0.0.0.0:8000

echo "   프론트엔드 서버 시작..."
npm run dev -- --host 0.0.0.0 --port 5173 > ../frontend.log 2>&1 &
FRONTEND_PID=$!
echo "   ✅ 프론트엔드 시작됨 (PID: $FRONTEND_PID)"

sleep 5

# 6. 상태 확인
echo ""
echo "🔍 서비스 상태 확인 중..."
sleep 2

if curl -s http://localhost:8000/ > /dev/null 2>&1; then
    echo "   ✅ 백엔드 서버 정상 작동"
else
    echo "   ⚠️  백엔드 서버 응답 없음"
fi

if curl -s http://localhost:5173/ > /dev/null 2>&1; then
    echo "   ✅ 프론트엔드 서버 정상 작동"
else
    echo "   ⚠️  프론트엔드 서버 응답 없음"
fi

# 7. 접속 정보
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 서버가 시작되었습니다!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 로컬 접속:"
echo "   🌐 Frontend:  http://localhost:5173"
echo "   🔌 Backend:   http://localhost:8000"
echo "   📚 API Docs:  http://localhost:8000/docs"
echo ""

# 로컬 IP 주소
if [[ "$OSTYPE" == "darwin"* ]]; then
    LOCAL_IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "")
else
    LOCAL_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || echo "")
fi

if [ ! -z "$LOCAL_IP" ]; then
    echo "📡 로컬 네트워크 접속 (같은 Wi-Fi):"
    echo "   🌐 Frontend:  http://$LOCAL_IP:5173"
    echo "   🔌 Backend:   http://$LOCAL_IP:8000"
    echo ""
fi

echo "🌐 인터넷 접속 (ngrok 필요):"
echo "   1. ngrok 설치: brew install ngrok/ngrok/ngrok"
echo "   2. ngrok 설정: https://dashboard.ngrok.com/signup"
echo "   3. 터널 생성: ngrok http 5173"
echo ""
echo "📊 서버 관리:"
echo "   로그 확인: tail -f backend.log frontend.log"
echo "   서버 중지: kill $BACKEND_PID $FRONTEND_PID"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# PID 저장
echo "$BACKEND_PID" > .backend.pid
echo "$FRONTEND_PID" > .frontend.pid

echo ""
echo "서버가 백그라운드에서 실행 중입니다."
echo "종료하려면: kill \$(cat .backend.pid) \$(cat .frontend.pid)"

