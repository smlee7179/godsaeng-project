#!/bin/bash

# ngrok을 사용하여 인터넷 접근 가능하게 만들기

set -e

echo "🌐 ngrok 터널링 시작 중..."

# ngrok 설치 확인
if ! command -v ngrok &> /dev/null; then
    echo "❌ ngrok이 설치되어 있지 않습니다."
    echo ""
    echo "📥 ngrok 설치 방법:"
    echo "   macOS: brew install ngrok/ngrok/ngrok"
    echo "   또는: https://ngrok.com/download"
    echo ""
    echo "🔑 ngrok 계정 생성 및 인증:"
    echo "   1. https://dashboard.ngrok.com/signup 에서 계정 생성"
    echo "   2. https://dashboard.ngrok.com/get-started/your-authtoken 에서 토큰 확인"
    echo "   3. ngrok config add-authtoken YOUR_TOKEN 실행"
    exit 1
fi

# 서버가 실행 중인지 확인
if ! curl -s http://localhost:80 > /dev/null 2>&1 && ! curl -s http://localhost:8000 > /dev/null 2>&1; then
    echo "⚠️  서버가 실행되지 않았습니다."
    echo "먼저 ./start-server.sh를 실행하세요."
    exit 1
fi

# 포트 확인
PORT=80
if curl -s http://localhost:80 > /dev/null 2>&1; then
    PORT=80
elif curl -s http://localhost:8000 > /dev/null 2>&1; then
    PORT=8000
else
    echo "❌ 서버를 찾을 수 없습니다."
    exit 1
fi

echo "✅ 포트 $PORT에서 서버 발견"
echo "🚇 ngrok 터널 생성 중..."
echo ""

# ngrok 실행 (백그라운드)
ngrok http $PORT --log=stdout &
NGROK_PID=$!

# 터널 URL 확인을 위해 잠시 대기
sleep 3

# ngrok API를 통해 URL 가져오기
if command -v curl &> /dev/null; then
    NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"[^"]*"' | head -1 | cut -d'"' -f4)
    if [ ! -z "$NGROK_URL" ]; then
        echo ""
        echo "✅ 터널이 생성되었습니다!"
        echo ""
        echo "🌐 인터넷 접속 URL:"
        echo "   $NGROK_URL"
        echo ""
        echo "📋 이 URL을 어디서든 사용할 수 있습니다!"
        echo ""
        echo "🛑 ngrok 중지: Ctrl+C 또는 kill $NGROK_PID"
        echo ""
        
        # URL을 클립보드에 복사 (macOS)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo "$NGROK_URL" | pbcopy
            echo "📋 URL이 클립보드에 복사되었습니다!"
        fi
        
        # 대기
        wait $NGROK_PID
    else
        echo "⚠️  ngrok URL을 가져올 수 없습니다."
        echo "수동으로 확인: http://localhost:4040"
        wait $NGROK_PID
    fi
else
    echo "ngrok이 실행 중입니다."
    echo "터널 정보 확인: http://localhost:4040"
    wait $NGROK_PID
fi

