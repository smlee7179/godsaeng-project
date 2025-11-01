#!/usr/bin/env python3
"""
MongoDB Atlas 연결 테스트 스크립트
"""

import sys
from pymongo import MongoClient
from urllib.parse import quote_plus

# MongoDB Atlas 정보
USERNAME = "smlee2257_db_user"
PASSWORD = "MJBdSMaeBvSKgcZy"
DATABASE = "godsaeng"

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🔗 MongoDB Atlas 연결 테스트")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("")
print("📋 연결 정보:")
print(f"   Username: {USERNAME}")
print(f"   Database: {DATABASE}")
print("")

# 클러스터 호스트 입력
print("MongoDB Atlas 클러스터 호스트를 입력하세요:")
print("예: cluster0.xxxxx.mongodb.net")
print("(MongoDB Atlas → Database → Connect → Connect your application)")
print("")

cluster_host = input("클러스터 호스트: ").strip()

if not cluster_host:
    print("❌ 클러스터 호스트가 입력되지 않았습니다.")
    print("")
    print("MongoDB Atlas에서 확인 방법:")
    print("1. https://cloud.mongodb.com 접속")
    print("2. Database → Connect → Connect your application")
    print("3. 연결 문자열에서 cluster0.xxxxx.mongodb.net 부분 찾기")
    sys.exit(1)

# 연결 문자열 생성
username_encoded = quote_plus(USERNAME)
password_encoded = quote_plus(PASSWORD)
mongodb_url = f"mongodb+srv://{username_encoded}:{password_encoded}@{cluster_host}/{DATABASE}?retryWrites=true&w=majority"

print("")
print("🔍 연결 테스트 중...")
print(f"   연결 문자열: mongodb+srv://{USERNAME}:***@{cluster_host}/{DATABASE}")
print("")

try:
    client = MongoClient(mongodb_url, serverSelectionTimeoutMS=10000)
    
    # 연결 테스트
    client.admin.command('ping')
    
    print("✅ MongoDB Atlas 연결 성공!")
    print("")
    print(f"   데이터베이스: {DATABASE}")
    
    # 데이터베이스 목록 확인
    db_list = client.list_database_names()
    print(f"   사용 가능한 데이터베이스: {', '.join(db_list[:5])}")
    
    # 현재 데이터베이스 확인
    db = client[DATABASE]
    collections = db.list_collection_names()
    if collections:
        print(f"   컬렉션: {', '.join(collections)}")
    else:
        print("   컬렉션: (없음 - 첫 실행)")
    
    client.close()
    
    print("")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("✅ 연결 문자열:")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("")
    print(mongodb_url)
    print("")
    print("이 연결 문자열을 Render 배포 시 사용하세요!")
    print("")
    
    # 파일에 저장
    with open('.env.atlas', 'w') as f:
        f.write(f"# MongoDB Atlas 연결 정보\n")
        f.write(f"MONGODB_URL={mongodb_url}\n")
        f.write(f"DATABASE_NAME={DATABASE}\n")
    
    print("✅ .env.atlas 파일에 저장되었습니다!")
    print("")
    
except Exception as e:
    print(f"❌ MongoDB Atlas 연결 실패: {str(e)}")
    print("")
    print("확인 사항:")
    print("1. 클러스터가 생성되었는지 확인 (5분 소요 가능)")
    print("2. 네트워크 접근이 허용되었는지 확인:")
    print("   - Network Access → Add IP Address → Allow Access from Anywhere (0.0.0.0/0)")
    print("3. 사용자 이름과 비밀번호가 올바른지 확인")
    print("4. 클러스터 호스트가 올바른지 확인")
    print("")
    print("MongoDB Atlas 대시보드:")
    print("https://cloud.mongodb.com")
    sys.exit(1)

