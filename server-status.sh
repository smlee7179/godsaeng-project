#!/bin/bash
# 서버 상태 확인 스크립트

cd "$(dirname "$0")"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "GODSAENG 서버 상태"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 백엔드 확인
if curl -s http://localhost:8000/ > /dev/null 2>&1; then
    echo "✅ 백엔드 서버: 실행 중 (http://localhost:8000)"
else
    echo "❌ 백엔드 서버: 중지됨"
fi

# 프론트엔드 확인
if curl -s http://localhost:5173/ > /dev/null 2>&1; then
    echo "✅ 프론트엔드 서버: 실행 중 (http://localhost:5173)"
else
    echo "❌ 프론트엔드 서버: 중지됨"
fi

# MongoDB 확인
if pgrep -x mongod > /dev/null || docker ps | grep -q mongodb; then
    echo "✅ MongoDB: 실행 중"
else
    echo "⚠️  MongoDB: 중지됨 (서버 기능 제한)"
fi

# ngrok 확인
if pgrep -x ngrok > /dev/null; then
    NGROK_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | grep -o '"public_url":"[^"]*"' | head -1 | cut -d'"' -f4)
    if [ ! -z "$NGROK_URL" ]; then
        echo "✅ ngrok 터널: 활성화 ($NGROK_URL)"
    else
        echo "⚠️  ngrok: 실행 중이지만 URL 확인 실패"
    fi
else
    echo "ℹ️  ngrok: 비활성화"
fi

echo ""
echo "📝 접속 정보:"
echo "   로컬 Frontend: http://localhost:5173"
echo "   로컬 Backend:  http://localhost:8000"
echo "   API Docs:      http://localhost:8000/docs"

if [ -f "ngrok-url.txt" ]; then
    echo "   인터넷 접속:  $(cat ngrok-url.txt)"
fi

echo ""
