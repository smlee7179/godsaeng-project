#!/bin/bash

# 직접 실행 방식 (Docker 없이)

set -e

echo "🚀 GODSAENG 서버 직접 실행 중..."

# Python 확인
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3가 설치되어 있지 않습니다."
    exit 1
fi

# Node.js 확인
if ! command -v node &> /dev/null; then
    echo "❌ Node.js가 설치되어 있지 않습니다."
    exit 1
fi

# MongoDB 확인
if ! pgrep -x "mongod" > /dev/null && ! docker ps | grep -q mongodb; then
    echo "⚠️  MongoDB가 실행 중이지 않습니다."
    echo "MongoDB를 시작하거나 Docker로 MongoDB를 실행하세요."
    echo ""
    echo "Docker로 MongoDB 실행:"
    echo "  docker run -d -p 27017:27017 --name mongodb mongo:7.0"
    echo ""
    echo "또는 로컬 MongoDB 시작:"
    echo "  brew services start mongodb-community"
    exit 1
fi

# 백엔드 디렉토리로 이동
cd backend

# 가상 환경 확인
if [ ! -d "venv" ]; then
    echo "📦 Python 가상 환경 생성 중..."
    python3 -m venv venv
fi

# 가상 환경 활성화
echo "🔄 가상 환경 활성화 중..."
source venv/bin/activate

# 의존성 설치
if [ ! -f "venv/.installed" ]; then
    echo "📥 Python 의존성 설치 중..."
    pip install -r requirements.txt
    touch venv/.installed
fi

# secrets.json 확인
if [ ! -f "config/secrets.json" ]; then
    echo "📝 secrets.json 파일 생성 중..."
    mkdir -p config
    echo '{"JWT_SECRET_KEY": "'$(openssl rand -hex 32)'", "HUGGINGFACE_API_KEY": "", "GEMINI_API_KEY": ""}' > config/secrets.json
fi

# 환경 변수 설정
export MONGODB_URL=${MONGODB_URL:-mongodb://localhost:27017}
export DATABASE_NAME=${DATABASE_NAME:-godsaeng}
export AI_PROVIDER=${AI_PROVIDER:-huggingface}

echo "🚀 백엔드 서버 시작 중..."
echo "   Backend API: http://0.0.0.0:8000"
echo "   API Docs: http://0.0.0.0:8000/docs"
echo ""

# 백그라운드에서 백엔드 실행
uvicorn main:app --host 0.0.0.0 --port 8000 &
BACKEND_PID=$!

echo "✅ 백엔드 서버가 시작되었습니다 (PID: $BACKEND_PID)"
echo ""

# 프론트엔드 디렉토리로 이동
cd ../frontend

# 의존성 확인
if [ ! -d "node_modules" ]; then
    echo "📥 Node.js 의존성 설치 중..."
    npm install
fi

# 환경 변수 설정
export VITE_API_BASE_URL=http://0.0.0.0:8000

echo "🚀 프론트엔드 개발 서버 시작 중..."
echo "   Frontend: http://0.0.0.0:5173"
echo ""

# 프론트엔드 실행
npm run dev -- --host 0.0.0.0 --port 5173 &
FRONTEND_PID=$!

echo "✅ 프론트엔드 서버가 시작되었습니다 (PID: $FRONTEND_PID)"
echo ""
echo "📊 서비스 정보:"
echo "   - Frontend: http://0.0.0.0:5173"
echo "   - Backend API: http://0.0.0.0:8000"
echo "   - API Docs: http://0.0.0.0:8000/docs"
echo ""

# 로컬 IP 주소 확인
if [[ "$OSTYPE" == "darwin"* ]]; then
    LOCAL_IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "")
else
    LOCAL_IP=$(hostname -I | awk '{print $1}')
fi

if [ ! -z "$LOCAL_IP" ]; then
    echo "📡 로컬 네트워크 접속:"
    echo "   - Frontend: http://$LOCAL_IP:5173"
    echo "   - Backend API: http://$LOCAL_IP:8000"
    echo ""
fi

echo "🌐 인터넷 접속을 원하면 ngrok을 사용하세요:"
echo "   1. ngrok 설치: brew install ngrok/ngrok/ngrok"
echo "   2. ngrok 실행: ngrok http 5173"
echo ""
echo "🛑 서버 중지: kill $BACKEND_PID $FRONTEND_PID"
echo ""

# 대기
wait

