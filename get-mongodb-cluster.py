#!/usr/bin/env python3
"""
MongoDB Atlas 클러스터 정보 자동 확인
"""

import sys
import json
import subprocess
from pathlib import Path

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🔍 MongoDB Atlas 클러스터 정보 확인")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("")

# MongoDB Atlas 정보
USERNAME = "smlee2257_db_user"
PASSWORD = "MJBdSMaeBvSKgcZy"
DATABASE = "godsaeng"

print("📋 MongoDB Atlas 정보:")
print(f"   Username: {USERNAME}")
print(f"   Database: {DATABASE}")
print("")

print("MongoDB Atlas에서 클러스터 호스트를 확인하는 방법:")
print("1. https://cloud.mongodb.com 접속")
print("2. Database 메뉴 클릭")
print("3. 클러스터에서 'Connect' 버튼 클릭")
print("4. 'Connect your application' 선택")
print("5. 연결 문자열에서 cluster0.xxxxx.mongodb.net 부분 복사")
print("")

# 일반적인 클러스터 호스트 패턴 시도
common_patterns = [
    "cluster0.xxxxx.mongodb.net",
]

print("클러스터 호스트를 입력하세요:")
cluster_host = input("클러스터 호스트 (예: cluster0.xxxxx.mongodb.net): ").strip()

if not cluster_host or cluster_host == "cluster0.xxxxx.mongodb.net":
    print("❌ 실제 클러스터 호스트를 입력하세요.")
    print("")
    print("MongoDB Atlas 대시보드에서 확인:")
    print("https://cloud.mongodb.com")
    sys.exit(1)

print("")
print(f"✅ 클러스터 호스트: {cluster_host}")
print("")

# 연결 테스트로 넘어가기
print("🔍 연결 테스트를 진행합니다...")
print("")

# test-mongodb-connection.py 실행
result = subprocess.run([
    sys.executable,
    str(Path(__file__).parent / "test-mongodb-connection.py")
], input=f"{cluster_host}\n", text=True, capture_output=False)

sys.exit(result.returncode)

