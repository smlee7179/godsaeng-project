#!/bin/bash

# ngrok 터널 자동 시작 스크립트

cd "$(dirname "$0")"

if ! command -v ngrok &> /dev/null; then
    echo "❌ ngrok이 설치되어 있지 않습니다."
    echo "설치 중..."
    brew install ngrok/ngrok/ngrok
fi

# 서버 확인
if ! curl -s http://localhost:5173 > /dev/null 2>&1; then
    echo "❌ 프론트엔드 서버가 실행 중이지 않습니다."
    echo "먼저 ./setup-and-start.sh를 실행하세요."
    exit 1
fi

echo "🌐 ngrok 터널 시작 중..."
echo ""
echo "⚠️  ngrok 계정이 필요합니다:"
echo "   1. https://dashboard.ngrok.com/signup 에서 계정 생성"
echo "   2. https://dashboard.ngrok.com/get-started/your-authtoken 에서 토큰 확인"
echo "   3. 아래 명령어로 인증:"
echo "      ngrok config add-authtoken YOUR_TOKEN"
echo ""
echo "인증 완료 후 Enter 키를 누르세요..."
read

# ngrok 인증 확인
if ! ngrok config check &> /dev/null; then
    echo "❌ ngrok 인증이 필요합니다."
    echo "토큰 확인: https://dashboard.ngrok.com/get-started/your-authtoken"
    echo "인증 명령어: ngrok config add-authtoken YOUR_TOKEN"
    exit 1
fi

echo "✅ ngrok 인증 확인됨"
echo "🚇 터널 생성 중..."
echo ""

# ngrok 실행
ngrok http 5173 --log=stdout &
NGROK_PID=$!

sleep 3

# 터널 URL 확인
if command -v curl &> /dev/null; then
    NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"[^"]*"' | head -1 | cut -d'"' -f4)
    
    if [ ! -z "$NGROK_URL" ]; then
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "✅ 터널이 생성되었습니다!"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "🌐 인터넷 접속 URL:"
        echo "   $NGROK_URL"
        echo ""
        echo "📋 이 URL을 어디서든 사용할 수 있습니다!"
        echo ""
        
        # URL을 파일에 저장
        echo "$NGROK_URL" > ngrok-url.txt
        echo "URL이 ngrok-url.txt 파일에 저장되었습니다."
        echo ""
        
        # macOS 클립보드에 복사
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo "$NGROK_URL" | pbcopy
            echo "📋 URL이 클립보드에 복사되었습니다!"
            echo ""
        fi
        
        echo "🛑 ngrok 중지: Ctrl+C 또는 kill $NGROK_PID"
        echo "📊 터널 정보: http://localhost:4040"
        echo ""
        
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

