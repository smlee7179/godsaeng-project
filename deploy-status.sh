#!/bin/bash
# 배포 상태 확인 스크립트

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 GODSAENG 배포 상태 확인"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Git 상태 확인
echo "📦 Git 상태:"
if [ -d ".git" ]; then
    BRANCH=$(git branch --show-current)
    REMOTE=$(git remote get-url origin 2>/dev/null || echo "설정되지 않음")
    echo "   브랜치: $BRANCH"
    echo "   원격 저장소: $REMOTE"
    
    if [ -n "$(git status --porcelain)" ]; then
        echo "   ⚠️  커밋되지 않은 변경사항 있음"
    else
        echo "   ✅ 모든 변경사항 커밋됨"
    fi
else
    echo "   ❌ Git 저장소 미초기화"
fi

echo ""
echo "📋 배포 준비 상태:"
echo ""

# 필수 파일 확인
echo "📁 필수 파일 확인:"
[ -f "render.yaml" ] && echo "   ✅ render.yaml" || echo "   ❌ render.yaml"
[ -f "backend/Procfile" ] && echo "   ✅ backend/Procfile" || echo "   ❌ backend/Procfile"
[ -f "backend/requirements.txt" ] && echo "   ✅ backend/requirements.txt" || echo "   ❌ backend/requirements.txt"
[ -f "frontend/package.json" ] && echo "   ✅ frontend/package.json" || echo "   ❌ frontend/package.json"
[ -f "DEPLOY_RENDER.md" ] && echo "   ✅ DEPLOY_RENDER.md" || echo "   ❌ DEPLOY_RENDER.md"

echo ""
echo "🌐 Render 배포 링크:"
echo "   백엔드: https://dashboard.render.com/new/web-service"
echo "   프론트엔드: https://dashboard.render.com/new/static-site"
echo ""
echo "📚 배포 가이드:"
echo "   빠른 가이드: QUICK_DEPLOY.md"
echo "   상세 가이드: DEPLOY_RENDER.md"
echo "   체크리스트: RENDER_SETUP.md"
echo ""

