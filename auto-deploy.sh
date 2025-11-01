#!/bin/bash

# 자동 배포 스크립트 - GitHub 및 Render 배포 준비

cd "$(dirname "$0")"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 GODSAENG 자동 배포 준비"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Git 상태 확인
if [ ! -d ".git" ]; then
    echo "❌ Git 저장소가 초기화되지 않았습니다."
    echo "Git 초기화 중..."
    git init
    git add .
    git commit -m "Initial commit: GODSAENG Project"
    git branch -M main
    echo "✅ Git 초기화 완료"
fi

# 현재 브랜치 확인
BRANCH=$(git branch --show-current)
echo "📦 현재 브랜치: $BRANCH"

# 변경사항 확인
if [ -n "$(git status --porcelain)" ]; then
    echo ""
    echo "📝 변경사항을 커밋합니다..."
    git add .
    git commit -m "Update: Prepare for deployment"
    echo "✅ 변경사항 커밋 완료"
fi

# 최근 커밋 확인
echo ""
echo "📋 최근 커밋:"
git log --oneline -3

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 배포 준비 완료!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 다음 단계:"
echo ""
echo "1️⃣  GitHub 저장소 생성:"
echo "   - https://github.com/new 에서 새 저장소 생성"
echo "   - 저장소 이름: godsaeng-project (또는 원하는 이름)"
echo "   - Public 또는 Private 선택"
echo "   - README, .gitignore, license 추가하지 않기 (이미 있음)"
echo ""
echo "2️⃣  GitHub에 푸시:"
echo "   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
echo "   git push -u origin main"
echo ""
echo "3️⃣  MongoDB Atlas 설정:"
echo "   - https://www.mongodb.com/cloud/atlas/register"
echo "   - 무료 클러스터 생성 (M0)"
echo "   - 연결 문자열 복사"
echo ""
echo "4️⃣  Render 배포:"
echo "   - https://dashboard.render.com"
echo "   - FINAL_DEPLOYMENT_GUIDE.md 파일 참고"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

