#!/bin/bash

# Render 로그 자동 확인 스크립트

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 Render 배포 상태 자동 확인"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

BACKEND_URL="https://godsaeng-backend.onrender.com"
FRONTEND_URL="https://godsaeng-frontend.onrender.com"

echo "백엔드 서비스:"
echo "   URL: $BACKEND_URL"
echo ""

# 백엔드 헬스체크
if curl -s -o /dev/null -w "%{http_code}" "$BACKEND_URL/health" | grep -q "200"; then
    echo "   ✅ 백엔드: 정상 작동"
    curl -s "$BACKEND_URL/health" | python3 -m json.tool 2>/dev/null || echo "   헬스체크 응답 확인"
elif curl -s -o /dev/null -w "%{http_code}" "$BACKEND_URL/health" | grep -q "502"; then
    echo "   ❌ 백엔드: 502 Bad Gateway"
    echo "   → Render 대시보드에서 로그 확인 필요"
    echo "   → 환경 변수 MONGODB_URL 확인"
else
    echo "   ⚠️  백엔드: 응답 확인 중..."
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$BACKEND_URL/health")
    echo "   상태 코드: $STATUS"
fi

echo ""
echo "프론트엔드 서비스:"
echo "   URL: $FRONTEND_URL"
echo ""

# 프론트엔드 확인
FRONTEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$FRONTEND_URL")
if [ "$FRONTEND_STATUS" = "200" ]; then
    echo "   ✅ 프론트엔드: 정상 작동"
elif [ "$FRONTEND_STATUS" = "404" ]; then
    echo "   ❌ 프론트엔드: 404 Not Found"
    echo "   → 배포 진행 중이거나 서비스 미생성"
else
    echo "   ⚠️  프론트엔드: 상태 코드 $FRONTEND_STATUS"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Render 대시보드 로그 확인:"
echo ""
echo "백엔드 로그:"
echo "   https://dashboard.render.com → godsaeng-backend → Logs"
echo ""
echo "프론트엔드 로그:"
echo "   https://dashboard.render.com → godsaeng-frontend → Logs"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# macOS에서 브라우저 열기
if command -v open > /dev/null; then
    read -p "Render 대시보드를 브라우저에서 열까요? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open "https://dashboard.render.com"
    fi
fi

