#!/bin/bash

# MongoDB Atlas 연결 테스트 스크립트

cd "$(dirname "$0")"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔗 MongoDB Atlas 연결 설정"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 사용자 정보
USERNAME="smlee2257_db_user"
PASSWORD="MJBdSMaeBvSKgcZy"
DATABASE="godsaeng"

echo "📋 MongoDB Atlas 정보:"
echo "   Username: $USERNAME"
echo "   Database: $DATABASE"
echo ""

# 연결 문자열 입력
echo "MongoDB Atlas 클러스터 정보를 입력하세요:"
echo ""
read -p "클러스터 호스트 (예: cluster0.xxxxx.mongodb.net): " CLUSTER_HOST

if [ -z "$CLUSTER_HOST" ]; then
    echo "❌ 클러스터 호스트가 입력되지 않았습니다."
    echo ""
    echo "MongoDB Atlas에서 클러스터 호스트 확인 방법:"
    echo "1. MongoDB Atlas 대시보드 접속"
    echo "2. Database → Connect → Connect your application"
    echo "3. 연결 문자열에서 cluster0.xxxxx.mongodb.net 부분 복사"
    exit 1
fi

# 연결 문자열 생성
MONGODB_URL="mongodb+srv://${USERNAME}:${PASSWORD}@${CLUSTER_HOST}/${DATABASE}?retryWrites=true&w=majority"

echo ""
echo "✅ 생성된 연결 문자열:"
echo "   $MONGODB_URL"
echo ""

# Python으로 연결 테스트
echo "🔍 연결 테스트 중..."
cd backend

if [ ! -d "venv" ]; then
    echo "Python 가상환경 생성 중..."
    python3 -m venv venv
fi

source venv/bin/activate

# pymongo 설치 확인
pip install pymongo -q

# 연결 테스트
python3 << PYTHON
import sys
from pymongo import MongoClient
from urllib.parse import quote_plus

try:
    # 연결 문자열
    username = quote_plus("${USERNAME}")
    password = quote_plus("${PASSWORD}")
    cluster = "${CLUSTER_HOST}"
    database = "${DATABASE}"
    
    uri = f"mongodb+srv://{username}:{password}@{cluster}/{database}?retryWrites=true&w=majority"
    
    print(f"연결 시도: mongodb+srv://{username}:***@{cluster}/{database}")
    
    client = MongoClient(uri, serverSelectionTimeoutMS=5000)
    
    # 연결 테스트
    client.admin.command('ping')
    
    print("✅ MongoDB Atlas 연결 성공!")
    print(f"   데이터베이스: {database}")
    
    # 데이터베이스 목록 확인
    dbs = client.list_database_names()
    print(f"   사용 가능한 데이터베이스: {', '.join(dbs[:5])}")
    
    client.close()
    sys.exit(0)
    
except Exception as e:
    print(f"❌ MongoDB Atlas 연결 실패: {str(e)}")
    print("")
    print("확인 사항:")
    print("1. 클러스터가 생성되었는지 확인")
    print("2. 네트워크 접근이 허용되었는지 확인 (0.0.0.0/0)")
    print("3. 사용자 이름과 비밀번호가 올바른지 확인")
    print("4. 클러스터 호스트가 올바른지 확인")
    sys.exit(1)
PYTHON

if [ $? -eq 0 ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ MongoDB Atlas 연결 성공!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📝 연결 문자열:"
    echo "   $MONGODB_URL"
    echo ""
    echo "이 연결 문자열을 Render 배포 시 사용하세요!"
    echo ""
    echo "환경 변수 설정:"
    echo "   MONGODB_URL=$MONGODB_URL"
    echo ""
    
    # .env 파일에 저장
    echo "# MongoDB Atlas 연결 정보" > .env.atlas
    echo "MONGODB_URL=$MONGODB_URL" >> .env.atlas
    echo "DATABASE_NAME=$DATABASE" >> .env.atlas
    echo ""
    echo "✅ .env.atlas 파일에 저장되었습니다!"
else
    echo ""
    echo "❌ 연결 실패. 위의 확인 사항을 점검하세요."
    exit 1
fi

