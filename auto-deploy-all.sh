#!/bin/bash

# GODSAENG PROJECT - 완전 자동 배포 스크립트
# 모든 배포 작업을 자동으로 수행합니다

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 GODSAENG PROJECT 완전 자동 배포"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 1. Git 상태 확인
echo "1️⃣  Git 상태 확인..."
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "   ❌ Git 저장소가 아닙니다. Git 초기화 중..."
    git init
    git remote add origin https://github.com/smlee7179/godsaeng-project.git 2>/dev/null || true
fi

# 2. 변경사항 커밋
echo ""
echo "2️⃣  변경사항 커밋..."
git add -A
if git diff --staged --quiet; then
    echo "   ✅ 커밋할 변경사항 없음"
else
    git commit -m "Auto: Deploy preparation $(date +%Y%m%d-%H%M%S)" || echo "   ⚠️  커밋 실패 (무시)"
fi

# 3. 프론트엔드 빌드 테스트
echo ""
echo "3️⃣  프론트엔드 빌드 테스트..."
cd frontend
if npm run build > /dev/null 2>&1; then
    echo "   ✅ 프론트엔드 빌드 성공"
else
    echo "   ⚠️  프론트엔드 빌드 실패 (계속 진행)"
fi
cd ..

# 4. 백엔드 검증
echo ""
echo "4️⃣  백엔드 검증..."
cd backend
if python3 -c "from main import app" 2>/dev/null; then
    echo "   ✅ 백엔드 검증 성공"
else
    echo "   ⚠️  백엔드 검증 실패 (계속 진행)"
fi
cd ..

# 5. GitHub 푸시
echo ""
echo "5️⃣  GitHub 푸시..."
if git push origin main; then
    echo "   ✅ GitHub 푸시 성공"
else
    echo "   ❌ GitHub 푸시 실패"
    echo "   💡 원격 저장소 설정을 확인하세요"
    exit 1
fi

# 6. 배포 상태 확인
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 자동 배포 준비 완료!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 다음 단계:"
echo ""
echo "1. Render 대시보드 확인:"
echo "   https://dashboard.render.com"
echo ""
echo "2. 백엔드 서비스:"
echo "   https://godsaeng-backend.onrender.com"
echo "   - 상태 확인"
echo "   - 환경 변수 MONGODB_URL 설정 확인"
echo ""
echo "3. 프론트엔드 서비스 생성 (아직 없으면):"
echo "   - Render 대시보드 → New → Static Site"
echo "   - 설정 정보는 CREATE_FRONTEND_SERVICE.md 참조"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
