#!/bin/bash

# Render 클라우드 배포 스크립트

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 GODSAENG 프로젝트 Render 배포"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Git 저장소 확인
if [ ! -d ".git" ]; then
    echo "❌ Git 저장소가 초기화되지 않았습니다."
    echo ""
    echo "GitHub 저장소 설정:"
    echo "  1. GitHub에서 새 저장소 생성"
    echo "  2. 다음 명령어 실행:"
    echo ""
    echo "     git init"
    echo "     git add ."
    echo "     git commit -m 'Initial commit'"
    echo "     git branch -M main"
    echo "     git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
    echo "     git push -u origin main"
    echo ""
    exit 1
fi

# Git 상태 확인
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  커밋되지 않은 변경사항이 있습니다."
    read -p "계속 진행하시겠습니까? (y/n): " confirm
    if [ "$confirm" != "y" ]; then
        exit 1
    fi
fi

echo "✅ Git 저장소 확인 완료"
echo ""

# 배포 확인
echo "📋 배포 전 체크리스트:"
echo ""
echo "1. ✅ GitHub 저장소에 코드 푸시 완료"
echo "2. ⚠️  MongoDB Atlas 설정 완료 (DEPLOY_RENDER.md 참고)"
echo "3. ⚠️  Render 계정 생성 완료 (https://render.com)"
echo ""
read -p "모든 항목이 완료되었나요? (y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo ""
    echo "📚 배포 가이드: DEPLOY_RENDER.md 파일을 참고하세요."
    exit 1
fi

echo ""
echo "🔗 Render 배포 링크:"
echo ""
echo "   백엔드 배포: https://dashboard.render.com/new/web-service"
echo "   프론트엔드 배포: https://dashboard.render.com/new/static-site"
echo ""
echo "📝 배포 가이드: DEPLOY_RENDER.md 파일을 참고하세요."
echo ""

# 최신 코드 푸시 확인
echo "현재 브랜치: $(git branch --show-current)"
echo "최근 커밋:"
git log --oneline -3
echo ""

read -p "최신 코드를 GitHub에 푸시하시겠습니까? (y/n): " push_confirm
if [ "$push_confirm" == "y" ]; then
    echo ""
    echo "GitHub에 푸시 중..."
    git add .
    git commit -m "Prepare for Render deployment" || echo "변경사항 없음"
    git push origin main || git push origin master
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ GitHub 푸시 완료!"
        echo ""
        echo "이제 Render 대시보드에서 배포를 시작할 수 있습니다."
        echo ""
        echo "1. https://dashboard.render.com 접속"
        echo "2. 'New +' → 'Web Service' 선택 (백엔드)"
        echo "3. GitHub 저장소 연결"
        echo "4. DEPLOY_RENDER.md의 설정값 입력"
        echo ""
    else
        echo ""
        echo "❌ GitHub 푸시 실패"
        echo "원격 저장소 설정을 확인하세요."
        exit 1
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 배포 준비 완료!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

