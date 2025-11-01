#!/bin/bash

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧪 서버 접근 테스트 스크립트"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

BACKEND_URL="https://godsaeng-backend.onrender.com"
FRONTEND_URL="https://godsaeng-frontend.onrender.com"

# 색상 코드
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

test_endpoint() {
    local url=$1
    local name=$2
    local expected_code=${3:-200}
    
    echo -n "테스트 중: $name... "
    
    response=$(curl -s -o /dev/null -w "%{http_code}" --max-time 30 "$url")
    
    if [ "$response" = "$expected_code" ]; then
        echo -e "${GREEN}✅ 성공${NC} (HTTP $response)"
        return 0
    elif [ "$response" = "000" ]; then
        echo -e "${YELLOW}⚠️  연결 시간 초과${NC} (서비스가 슬립 모드일 수 있음)"
        return 1
    else
        echo -e "${RED}❌ 실패${NC} (HTTP $response)"
        return 1
    fi
}

echo "1️⃣  백엔드 서비스 테스트:"
echo ""

# 루트 엔드포인트
test_endpoint "$BACKEND_URL/" "루트 엔드포인트" 200

# 헬스체크
test_endpoint "$BACKEND_URL/health" "헬스체크" 200

# 설정 정보
test_endpoint "$BACKEND_URL/config" "설정 정보" 200

# API 문서
test_endpoint "$BACKEND_URL/docs" "Swagger UI" 200
test_endpoint "$BACKEND_URL/redoc" "ReDoc" 200
test_endpoint "$BACKEND_URL/openapi.json" "OpenAPI JSON" 200

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "2️⃣  프론트엔드 서비스 테스트:"
echo ""

test_endpoint "$FRONTEND_URL" "프론트엔드 메인" 200

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "3️⃣  상세 응답 확인:"
echo ""

echo "📊 백엔드 헬스체크 응답:"
echo ""
curl -s --max-time 30 "$BACKEND_URL/health" | python3 -m json.tool 2>/dev/null || echo "응답을 파싱할 수 없습니다"
echo ""

echo "📊 백엔드 루트 응답:"
echo ""
curl -s --max-time 30 "$BACKEND_URL/" | python3 -m json.tool 2>/dev/null || echo "응답을 파싱할 수 없습니다"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "4️⃣  브라우저에서 테스트:"
echo ""
echo "백엔드 API 문서:"
echo "   $BACKEND_URL/docs"
echo ""
echo "프론트엔드:"
echo "   $FRONTEND_URL"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ 테스트 완료!"
echo ""

