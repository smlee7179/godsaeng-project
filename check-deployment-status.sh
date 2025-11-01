#!/bin/bash

# Render 배포 상태 확인 스크립트

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Render 배포 상태 확인"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

BACKEND_URL="https://godsaeng-backend.onrender.com"
FRONTEND_URL="https://godsaeng-frontend.onrender.com"

echo "🔍 백엔드 상태 확인 중..."
if curl -s -f "$BACKEND_URL/" > /dev/null 2>&1; then
    echo "✅ 백엔드: 배포 완료 및 실행 중!"
    echo "   URL: $BACKEND_URL"
    echo "   API 문서: $BACKEND_URL/docs"
else
    echo "⏳ 백엔드: 아직 배포 중이거나 오류 발생"
    echo "   Render 대시보드에서 로그 확인: https://dashboard.render.com"
fi

echo ""
echo "🔍 프론트엔드 상태 확인 중..."
if curl -s -f "$FRONTEND_URL" > /dev/null 2>&1; then
    echo "✅ 프론트엔드: 배포 완료 및 실행 중!"
    echo "   URL: $FRONTEND_URL"
else
    echo "⏳ 프론트엔드: 아직 배포 중이거나 오류 발생"
    echo "   Render 대시보드에서 로그 확인: https://dashboard.render.com"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 Render 대시보드에서 확인:"
echo "   https://dashboard.render.com"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

