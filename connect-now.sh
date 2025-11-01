#!/bin/bash

# MongoDB Atlas 즉시 연결 스크립트

cd "$(dirname "$0")"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔗 MongoDB Atlas 즉시 연결"
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

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 MongoDB Atlas에서 클러스터 호스트 확인"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. MongoDB Atlas 대시보드 접속:"
echo "   https://cloud.mongodb.com"
echo ""
echo "2. 클러스터 정보 확인:"
echo "   - Database 메뉴 → 클러스터 선택"
echo "   - 'Connect' 버튼 클릭"
echo "   - 'Connect your application' 선택"
echo "   - 연결 문자열에서 cluster0.xxxxx.mongodb.net 부분 확인"
echo "   - 예: cluster0.abc123.mongodb.net"
echo ""

read -p "클러스터 호스트를 입력하세요 (예: cluster0.xxxxx.mongodb.net): " CLUSTER_HOST

if [ -z "$CLUSTER_HOST" ] || [ "$CLUSTER_HOST" = "cluster0.xxxxx.mongodb.net" ]; then
    echo ""
    echo "❌ 실제 클러스터 호스트를 입력해주세요."
    echo ""
    echo "MongoDB Atlas에서 확인 방법:"
    echo "1. https://cloud.mongodb.com 접속"
    echo "2. Database → Connect → Connect your application"
    echo "3. 연결 문자열에서 cluster0.xxxxx.mongodb.net 부분 복사"
    echo ""
    echo "다시 시도하려면: ./connect-now.sh"
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 연결 테스트 중..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 연결 문자열 생성
MONGODB_URL="mongodb+srv://${USERNAME}:${PASSWORD}@${CLUSTER_HOST}/${DATABASE}?retryWrites=true&w=majority"

# Python으로 연결 테스트
cd backend

if [ ! -d "venv" ]; then
    echo "Python 가상환경 생성 중..."
    python3 -m venv venv
fi

source venv/bin/activate
pip install pymongo motor -q

echo "연결 시도 중..."
echo ""

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
    
    print(f"   클러스터: {cluster}")
    print(f"   데이터베이스: {database}")
    print("")
    
    client = MongoClient(uri, serverSelectionTimeoutMS=20000)
    
    # 연결 테스트
    result = client.admin.command('ping')
    
    print("✅ MongoDB Atlas 연결 성공!")
    print("")
    
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
    
    # 인덱스 생성 (애플리케이션 준비)
    print("")
    print("📝 데이터베이스 초기화 중...")
    
    # users 컬렉션 인덱스
    db.users.create_index("email", unique=True)
    print("   ✅ users.email 인덱스 생성")
    
    # daily_logs 컬렉션 인덱스
    db.daily_logs.create_index([("user_id", 1), ("timestamp", -1)])
    print("   ✅ daily_logs 인덱스 생성")
    
    # ai_reports 컬렉션 인덱스
    db.ai_reports.create_index([("user_id", 1), ("date", -1)])
    print("   ✅ ai_reports 인덱스 생성")
    
    client.close()
    
    # 연결 문자열 저장
    import os
    with open('../.env.atlas', 'w') as f:
        f.write(f"# MongoDB Atlas 연결 정보\n")
        f.write(f"MONGODB_URL={uri}\n")
        f.write(f"DATABASE_NAME={database}\n")
    
    print("")
    print("✅ .env.atlas 파일에 저장되었습니다!")
    print("")
    
    sys.exit(0)
    
except Exception as e:
    error_msg = str(e)
    print(f"❌ MongoDB Atlas 연결 실패: {error_msg}")
    print("")
    
    if "authentication" in error_msg.lower():
        print("확인 사항:")
        print("1. 사용자 이름과 비밀번호가 올바른지 확인")
        print("2. Database Access에서 사용자가 생성되었는지 확인")
    elif "network" in error_msg.lower() or "timeout" in error_msg.lower():
        print("확인 사항:")
        print("1. 네트워크 접근 허용 확인:")
        print("   - Network Access → Add IP Address")
        print("   - 'Allow Access from Anywhere' 선택 (0.0.0.0/0)")
        print("2. 클러스터가 완전히 생성되었는지 확인 (5분 소요 가능)")
    elif "dns" in error_msg.lower() or "not found" in error_msg.lower():
        print("확인 사항:")
        print("1. 클러스터 호스트가 올바른지 확인")
        print("2. 클러스터가 완전히 생성되었는지 확인")
    else:
        print("확인 사항:")
        print("1. 클러스터 상태 확인")
        print("2. 네트워크 접근 확인")
        print("3. 사용자 확인")
    
    print("")
    print("MongoDB Atlas 대시보드:")
    print("https://cloud.mongodb.com")
    sys.exit(1)
PYTHON

if [ $? -eq 0 ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ MongoDB Atlas 연결 및 설정 완료!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📝 저장된 연결 정보:"
    echo "   파일: .env.atlas"
    cat ../.env.atlas | grep -v "^#"
    echo ""
    echo "📋 다음 단계:"
    echo "   1. ✅ MongoDB Atlas 연결 완료"
    echo "   2. ✅ 데이터베이스 초기화 완료 (인덱스 생성)"
    echo "   3. Render 배포 시 .env.atlas 파일의 MONGODB_URL 사용"
    echo "   4. 로컬 테스트 시:"
    echo "      export MONGODB_URL=\$(cat .env.atlas | grep MONGODB_URL | cut -d'=' -f2)"
    echo "      cd backend && uvicorn main:app --reload"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    echo ""
    echo "❌ 연결 실패. 위의 확인 사항을 점검하세요."
    exit 1
fi

