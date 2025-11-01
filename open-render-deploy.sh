#!/bin/bash

# Render 배포를 위해 브라우저 자동 열기 스크립트

cd "$(dirname "$0")"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Render 배포를 위해 브라우저를 엽니다"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# MongoDB 연결 문자열 읽기
MONGODB_URL=$(grep MONGODB_URL .env.atlas 2>/dev/null | cut -d'=' -f2)

if [ -z "$MONGODB_URL" ]; then
    echo "⚠️  .env.atlas 파일을 찾을 수 없습니다."
    MONGODB_URL="mongodb+srv://smlee2257_db_user:MJBdSMaeBvSKgcZy@cluster0.zlcflwi.mongodb.net/godsaeng?retryWrites=true&w=majority"
    echo "기본값 사용: $MONGODB_URL"
fi

echo "📋 배포 정보:"
echo "   GitHub 저장소: smlee7179/godsaeng-project"
echo "   MongoDB: 연결 완료"
echo ""

echo "🔗 Render Blueprint 배포 링크를 엽니다..."
echo ""

# macOS에서 브라우저 열기
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Blueprint 배포 링크 열기
    open "https://dashboard.render.com/new/blueprint-spec"
    
    echo "✅ 브라우저가 열렸습니다!"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📝 Render 배포 단계"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "1. 브라우저에서 GitHub 로그인 (처음만)"
    echo "2. 'Public Git repository' 입력:"
    echo "   smlee7179/godsaeng-project"
    echo ""
    echo "3. 'Apply' 클릭"
    echo ""
    echo "4. 환경 변수 추가:"
    echo "   MONGODB_URL=$MONGODB_URL"
    echo ""
    echo "5. 다시 'Apply' 클릭하여 배포 시작"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📋 MongoDB 연결 문자열:"
    echo "$MONGODB_URL"
    echo ""
    echo "이 값을 복사하여 Render 환경 변수에 추가하세요!"
    echo ""
else
    echo "macOS가 아닌 환경입니다. 다음 링크를 브라우저에서 열어주세요:"
    echo "https://dashboard.render.com/new/blueprint-spec"
fi

