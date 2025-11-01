#!/bin/bash

# Render API를 사용한 자동 배포 스크립트

cd "$(dirname "$0")"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Render API를 사용한 자동 배포"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# MongoDB 연결 문자열 읽기
if [ ! -f ".env.atlas" ]; then
    echo "❌ .env.atlas 파일을 찾을 수 없습니다."
    exit 1
fi

MONGODB_URL=$(grep MONGODB_URL .env.atlas | cut -d'=' -f2)
DATABASE_NAME=$(grep DATABASE_NAME .env.atlas | cut -d'=' -f2)

echo "📋 배포 정보:"
echo "   Repository: smlee7179/godsaeng-project"
echo "   MongoDB: 연결 완료"
echo ""

echo "⚠️  Render API를 사용하려면 API 키가 필요합니다."
echo "Render 대시보드에서 API 키를 생성해야 합니다."
echo ""
echo "1. Render 대시보드 접속: https://dashboard.render.com"
echo "2. Account Settings → API Keys"
echo "3. New API Key 생성"
echo "4. API 키를 환경 변수로 설정:"
echo "   export RENDER_API_KEY=your-api-key"
echo ""
echo "API 키를 설정한 후 다시 실행하세요."
echo ""
echo "또는 Render Blueprint를 사용하여 수동 배포:"
echo "   https://dashboard.render.com/new/blueprint-spec"
echo "   GitHub 저장소: smlee7179/godsaeng-project"
echo ""

