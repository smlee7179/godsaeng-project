#!/bin/bash

# Render 로그 직접 확인 스크립트

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Render 로그 확인 도구"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "현재 배포 상태 확인 중..."
echo ""

BACKEND_URL="https://godsaeng-backend.onrender.com"
FRONTEND_URL="https://godsaeng-frontend.onrender.com"

# 백엔드 확인
echo "백엔드:"
if curl -s -o /dev/null -w "%{http_code}" "$BACKEND_URL/health" | grep -q "200"; then
    echo "   ✅ 정상 작동"
elif curl -s -o /dev/null -w "%{http_code}" "$BACKEND_URL/health" | grep -q "502"; then
    echo "   ❌ 502 Bad Gateway - 로그 확인 필요"
elif curl -s -o /dev/null -w "%{http_code}" "$BACKEND_URL/health" | grep -q "503"; then
    echo "   ⏳ 503 Service Unavailable - 시작 중"
else
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$BACKEND_URL/health")
    echo "   ⚠️  상태: $STATUS"
fi

echo ""
echo "프론트엔드:"
FRONTEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$FRONTEND_URL")
if [ "$FRONTEND_STATUS" = "200" ]; then
    echo "   ✅ 정상 작동"
elif [ "$FRONTEND_STATUS" = "404" ]; then
    echo "   ❌ 404 Not Found"
else
    echo "   ⚠️  상태: $FRONTEND_STATUS"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Render 대시보드 로그 확인:"
echo ""
echo "백엔드 로그:"
echo "   https://dashboard.render.com"
echo "   → godsaeng-backend"
echo "   → Logs 탭"
echo ""
echo "프론트엔드 로그:"
echo "   → godsaeng-frontend"
echo "   → Logs 탭"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# macOS에서 브라우저 열기
if command -v open > /dev/null; then
    read -p "Render 대시보드를 브라우저에서 열까요? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open "https://dashboard.render.com"
        echo ""
        echo "✅ 브라우저에서 Render 대시보드를 열었습니다."
        echo ""
        echo "로그 확인 방법:"
        echo "1. godsaeng-backend 클릭"
        echo "2. Logs 탭 클릭"
        echo "3. 빌드 로그 및 실행 로그 확인"
    fi
fi

