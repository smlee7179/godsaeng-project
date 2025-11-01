#!/bin/bash

# 배포 시작 스크립트

cd "$(dirname "$0")"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 GODSAENG 배포 시작"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Git 상태 확인
echo "📦 Git 상태 확인..."
if [ ! -d ".git" ]; then
    echo "Git 초기화 중..."
    git init
    git add .
    git commit -m "Initial commit"
    git branch -M main
fi

BRANCH=$(git branch --show-current)
echo "현재 브랜치: $BRANCH"

# 원격 저장소 확인
REMOTE=$(git remote get-url origin 2>/dev/null)
if [ -z "$REMOTE" ]; then
    echo ""
    echo "⚠️  GitHub 원격 저장소가 설정되지 않았습니다."
    echo ""
    echo "다음 단계를 진행하세요:"
    echo ""
    echo "1. GitHub에서 새 저장소 생성:"
    echo "   https://github.com/new"
    echo ""
    echo "2. 저장소 생성 후 아래 명령어 실행:"
    echo "   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
    echo "   git push -u origin main"
    echo ""
    read -p "GitHub 저장소를 생성하셨나요? (y/n): " created
    if [ "$created" != "y" ]; then
        echo ""
        echo "먼저 GitHub 저장소를 생성해주세요:"
        echo "https://github.com/new"
        exit 1
    fi
    
    echo ""
    read -p "GitHub 저장소 URL을 입력하세요: " repo_url
    if [ -n "$repo_url" ]; then
        git remote add origin "$repo_url"
        echo "✅ 원격 저장소 추가 완료"
    fi
fi

# 변경사항 커밋
if [ -n "$(git status --porcelain)" ]; then
    echo ""
    echo "변경사항 커밋 중..."
    git add .
    git commit -m "Update: Deployment configuration"
fi

# GitHub 푸시
echo ""
echo "GitHub에 푸시 중..."
git push -u origin main 2>&1

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ GitHub 푸시 완료!"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📋 다음 단계:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "1️⃣  MongoDB Atlas 설정:"
    echo "   https://www.mongodb.com/cloud/atlas/register"
    echo "   (상세 가이드: cat DEPLOY_NOW.md)"
    echo ""
    echo "2️⃣  Render 배포:"
    echo "   https://dashboard.render.com"
    echo "   (상세 가이드: cat DEPLOY_NOW.md)"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    echo ""
    echo "⚠️  GitHub 푸시 실패"
    echo "원격 저장소 URL을 확인하세요."
    echo ""
    echo "현재 원격 저장소:"
    git remote -v
    echo ""
    echo "수동으로 푸시:"
    echo "  git push -u origin main"
fi

