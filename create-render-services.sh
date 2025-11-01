#!/bin/bash

# Render 서비스 생성 가이드 및 자동화 스크립트

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Render 서비스 생성 가이드"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "✅ 준비 완료된 설정:"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📌 프론트엔드 서비스 생성 정보"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "서비스 이름: godsaeng-frontend"
echo "타입: Static Site"
echo "Repository: smlee7179/godsaeng-project"
echo "Branch: main"
echo "Root Directory: frontend"
echo "Build Command: npm install && npm run build"
echo "Publish Directory: dist"
echo ""
echo "환경 변수:"
echo "  Key: VITE_API_BASE_URL"
echo "  Value: https://godsaeng-backend.onrender.com"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🔧 생성 방법:"
echo ""
echo "1. 브라우저에서 Render 대시보드 열기:"
echo "   https://dashboard.render.com"
echo ""
echo "2. 'New' 버튼 클릭 → 'Static Site' 선택"
echo ""
echo "3. 다음 정보 입력:"
echo "   - Connect: smlee7179/godsaeng-project"
echo "   - Name: godsaeng-frontend"
echo "   - Branch: main"
echo "   - Root Directory: frontend"
echo "   - Build Command: npm install && npm run build"
echo "   - Publish Directory: dist"
echo ""
echo "4. Environment Variables 섹션:"
echo "   - Key: VITE_API_BASE_URL"
echo "   - Value: https://godsaeng-backend.onrender.com"
echo ""
echo "5. 'Create Static Site' 클릭"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "또는 Blueprint을 사용하여 자동 생성:"
echo "   - Blueprints 메뉴에서 render.yaml 사용"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 브라우저 자동 열기 (macOS)
if command -v open > /dev/null; then
    read -p "Render 대시보드를 브라우저에서 열까요? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open "https://dashboard.render.com/web/new/static"
        echo ""
        echo "✅ 브라우저에서 Render 대시보드를 열었습니다."
    fi
fi

