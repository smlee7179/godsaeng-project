#!/bin/bash

# Render 자동 배포 스크립트

cd "$(dirname "$0")"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Render 자동 배포 시작"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Render CLI 확인
if ! command -v render &> /dev/null; then
    echo "Render CLI가 설치되어 있지 않습니다."
    echo "설치 중..."
    
    # macOS에서 Homebrew로 설치 시도
    if command -v brew &> /dev/null; then
        echo "Homebrew를 사용하여 Render CLI 설치 시도..."
        # Render CLI는 npm으로 설치 가능
        if command -v npm &> /dev/null; then
            npm install -g @render/cli 2>/dev/null || echo "npm 설치 실패"
        fi
    fi
fi

# MongoDB 연결 문자열 읽기
if [ ! -f ".env.atlas" ]; then
    echo "❌ .env.atlas 파일을 찾을 수 없습니다."
    exit 1
fi

MONGODB_URL=$(grep MONGODB_URL .env.atlas | cut -d'=' -f2)
DATABASE_NAME=$(grep DATABASE_NAME .env.atlas | cut -d'=' -f2)

echo "📋 배포 정보:"
echo "   MongoDB URL: mongodb+srv://***@cluster0.zlcflwi.mongodb.net/godsaeng"
echo "   Database: $DATABASE_NAME"
echo ""

# Render CLI 사용 가능 여부 확인
if command -v render &> /dev/null; then
    echo "✅ Render CLI 발견"
    echo ""
    echo "Render CLI를 사용한 자동 배포를 진행합니다..."
    echo ""
    
    # 로그인 확인
    if ! render whoami &> /dev/null; then
        echo "Render에 로그인이 필요합니다."
        echo "다음 명령어를 실행하세요:"
        echo "  render login"
        echo ""
        echo "또는 웹 브라우저에서 다음 링크를 열어 수동으로 배포하세요:"
        echo "  https://dashboard.render.com"
        exit 1
    fi
    
    echo "Render Blueprint 배포 중..."
    render blueprint create --from-file render.yaml || {
        echo "Blueprint 배포 실패. 수동 배포를 진행하세요."
        exit 1
    }
else
    echo "Render CLI를 사용할 수 없습니다."
    echo "웹 브라우저에서 수동 배포를 진행하세요."
    echo ""
    echo "Render 대시보드: https://dashboard.render.com"
    echo ""
fi

echo "✅ 배포 스크립트 완료"
