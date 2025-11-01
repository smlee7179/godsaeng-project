#!/bin/bash

# MongoDB Atlas 연결 설정 스크립트

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
echo "   Password: (설정됨)"
echo "   Database: $DATABASE"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 MongoDB Atlas 설정 확인"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. MongoDB Atlas 대시보드 접속:"
echo "   https://cloud.mongodb.com"
echo ""
echo "2. 클러스터 확인:"
echo "   - Database 메뉴에서 클러스터 상태 확인"
echo "   - 클러스터가 생성 중이면 완료될 때까지 대기 (약 5분)"
echo ""
echo "3. 연결 문자열 확인:"
echo "   - 클러스터에서 'Connect' 버튼 클릭"
echo "   - 'Connect your application' 선택"
echo "   - 연결 문자열에서 클러스터 호스트 찾기"
echo "   - 예: cluster0.xxxxx.mongodb.net"
echo ""
echo "4. 네트워크 접근 확인:"
echo "   - Network Access 메뉴"
echo "   - IP 주소 0.0.0.0/0 (Allow Access from Anywhere) 확인"
echo "   - 없으면 추가"
echo ""

read -p "위 단계를 완료하고 클러스터 호스트를 입력하세요 (예: cluster0.xxxxx.mongodb.net): " CLUSTER_HOST

if [ -z "$CLUSTER_HOST" ]; then
    echo "❌ 클러스터 호스트가 입력되지 않았습니다."
    exit 1
fi

# 연결 문자열 생성
MONGODB_URL="mongodb+srv://${USERNAME}:${PASSWORD}@${CLUSTER_HOST}/${DATABASE}?retryWrites=true&w=majority"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 연결 테스트 중..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "연결 문자열: mongodb+srv://${USERNAME}:***@${CLUSTER_HOST}/${DATABASE}"
echo ""

# Python으로 연결 테스트
cd backend

if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

source venv/bin/activate
pip install pymongo -q

python3 << PYTHON
import sys
from pymongo import MongoClient
from urllib.parse import quote_plus

try:
    username = quote_plus("${USERNAME}")
    password = quote_plus("${PASSWORD}")
    cluster = "${CLUSTER_HOST}"
    database = "${DATABASE}"
    
    uri = f"mongodb+srv://{username}:{password}@{cluster}/{database}?retryWrites=true&w=majority"
    
    print(f"연결 시도 중...")
    
    client = MongoClient(uri, serverSelectionTimeoutMS=15000)
    
    # 연결 테스트
    result = client.admin.command('ping')
    
    print("✅ MongoDB Atlas 연결 성공!")
    print(f"   데이터베이스: {database}")
    
    # 데이터베이스 목록 확인
    dbs = client.list_database_names()
    print(f"   사용 가능한 데이터베이스: {', '.join(dbs[:5])}")
    
    # 현재 데이터베이스 확인
    db = client[database]
    collections = db.list_collection_names()
    if collections:
        print(f"   컬렉션: {', '.join(collections)}")
    else:
        print(f"   컬렉션: (없음 - 첫 실행)")
    
    client.close()
    
    # 연결 문자열 저장
    with open('../.env.atlas', 'w') as f:
        f.write(f"# MongoDB Atlas 연결 정보\n")
        f.write(f"MONGODB_URL={uri}\n")
        f.write(f"DATABASE_NAME={database}\n")
    
    print("")
    print("✅ .env.atlas 파일에 저장되었습니다!")
    print("")
    print("📝 연결 문자열:")
    print(f"   {uri}")
    
    sys.exit(0)
    
except Exception as e:
    print(f"❌ MongoDB Atlas 연결 실패: {str(e)}")
    print("")
    print("확인 사항:")
    print("1. 클러스터가 생성 완료되었는지 확인 (약 5분 소요)")
    print("2. 네트워크 접근 허용 확인:")
    print("   - Network Access → Add IP Address")
    print("   - 'Allow Access from Anywhere' 선택 (0.0.0.0/0)")
    print("3. 사용자 이름과 비밀번호 확인")
    print("4. 클러스터 호스트 확인:")
    print("   - Database → Connect → Connect your application")
    print("   - 연결 문자열에서 cluster0.xxxxx.mongodb.net 확인")
    print("")
    print("MongoDB Atlas 대시보드:")
    print("https://cloud.mongodb.com")
    sys.exit(1)
PYTHON

if [ $? -eq 0 ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ MongoDB Atlas 연결 성공!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📝 다음 단계:"
    echo "   1. .env.atlas 파일에 연결 문자열 저장됨"
    echo "   2. Render 배포 시 이 연결 문자열 사용"
    echo "   3. 로컬 테스트 시:"
    echo "      export MONGODB_URL=$(cat ../.env.atlas | grep MONGODB_URL | cut -d'=' -f2)"
    echo ""
else
    echo ""
    echo "❌ 연결 실패. 위의 확인 사항을 점검하세요."
    exit 1
fi

