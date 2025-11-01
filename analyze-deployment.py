#!/usr/bin/env python3
"""
Render 배포 상태 자동 분석 스크립트
"""

import sys
import requests
import time
from urllib.parse import urlparse

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🔍 Render 배포 상태 자동 분석")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("")

BACKEND_URL = "https://godsaeng-backend.onrender.com"
FRONTEND_URL = "https://godsaeng-frontend.onrender.com"

def check_service(url, service_name):
    """서비스 상태 확인"""
    print(f"📊 {service_name} 상태 확인 중...")
    print(f"   URL: {url}")
    
    try:
        # 헤더 설정 (User-Agent 추가)
        headers = {
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
        }
        
        # 타임아웃 설정 (10초)
        response = requests.get(url, headers=headers, timeout=10, allow_redirects=True)
        
        status_code = response.status_code
        print(f"   HTTP 상태 코드: {status_code}")
        
        if status_code == 200:
            print(f"   ✅ {service_name}: 배포 완료 및 실행 중!")
            print(f"   응답 시간: {response.elapsed.total_seconds():.2f}초")
            
            # 응답 내용 확인
            if service_name == "백엔드":
                try:
                    data = response.json()
                    print(f"   응답 내용: {data}")
                except:
                    print(f"   응답 내용: {response.text[:100]}")
            
            return True
        elif status_code == 503:
            print(f"   ⏳ {service_name}: 배포 중이거나 시작 중...")
            print(f"   Render 무료 플랜은 첫 요청 시 약 50초 정도 걸릴 수 있습니다.")
            return False
        elif status_code == 404:
            print(f"   ❌ {service_name}: 서비스가 배포되지 않았거나 URL이 잘못되었습니다.")
            return False
        else:
            print(f"   ⚠️  {service_name}: 예상치 못한 상태 코드 ({status_code})")
            print(f"   응답 내용: {response.text[:200]}")
            return False
            
    except requests.exceptions.Timeout:
        print(f"   ⏳ {service_name}: 타임아웃 (서비스가 시작 중일 수 있습니다)")
        return False
    except requests.exceptions.ConnectionError:
        print(f"   ⏳ {service_name}: 연결 오류 (서비스가 아직 배포되지 않았습니다)")
        return False
    except Exception as e:
        print(f"   ❌ {service_name}: 오류 발생 - {str(e)}")
        return False

def check_backend_endpoints():
    """백엔드 엔드포인트 확인"""
    print("")
    print("📋 백엔드 엔드포인트 확인:")
    
    endpoints = [
        ("/", "루트"),
        ("/docs", "API 문서"),
        ("/api/auth/register", "회원가입"),
        ("/config", "설정"),
    ]
    
    for endpoint, name in endpoints:
        try:
            url = f"{BACKEND_URL}{endpoint}"
            response = requests.get(url, timeout=5, allow_redirects=True)
            status = "✅" if response.status_code == 200 else "⚠️"
            print(f"   {status} {endpoint} ({name}): {response.status_code}")
        except:
            print(f"   ⏳ {endpoint} ({name}): 확인 불가")

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("")

# 백엔드 확인
backend_ok = check_service(BACKEND_URL, "백엔드")

print("")

# 프론트엔드 확인
frontend_ok = check_service(FRONTEND_URL, "프론트엔드")

# 백엔드 엔드포인트 확인
if backend_ok:
    check_backend_endpoints()

print("")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("📊 배포 상태 요약")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("")

if backend_ok and frontend_ok:
    print("✅ 배포 완료!")
    print("")
    print("🌐 접속 URL:")
    print(f"   백엔드: {BACKEND_URL}")
    print(f"   프론트엔드: {FRONTEND_URL}")
    print(f"   API 문서: {BACKEND_URL}/docs")
    print("")
    print("✅ 모든 서비스가 정상적으로 실행 중입니다!")
elif backend_ok:
    print("⚠️  백엔드는 배포 완료되었지만 프론트엔드는 아직 배포 중입니다.")
    print(f"   백엔드 URL: {BACKEND_URL}")
    print(f"   API 문서: {BACKEND_URL}/docs")
    print("")
    print("프론트엔드 배포 완료까지 대기 중...")
elif frontend_ok:
    print("⚠️  프론트엔드는 배포 완료되었지만 백엔드는 아직 배포 중입니다.")
    print(f"   프론트엔드 URL: {FRONTEND_URL}")
    print("")
    print("백엔드 배포 완료까지 대기 중...")
else:
    print("⏳ 배포 진행 중...")
    print("")
    print("확인 사항:")
    print("1. Render 대시보드에서 배포 로그 확인")
    print("   https://dashboard.render.com")
    print("2. 배포 상태 확인 (약 5-10분 소요)")
    print("3. Render 무료 플랜은 첫 요청 시 약 50초 소요될 수 있음")
    print("")
    print("다시 확인하려면:")
    print("   python3 analyze-deployment.py")

print("")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

if not backend_ok or not frontend_ok:
    print("")
    print("🔄 30초 후 자동으로 다시 확인합니다...")
    time.sleep(30)
    print("")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("🔄 재확인 중...")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("")
    
    backend_ok = check_service(BACKEND_URL, "백엔드")
    print("")
    frontend_ok = check_service(FRONTEND_URL, "프론트엔드")
    
    print("")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    if backend_ok and frontend_ok:
        print("✅ 배포 완료!")
    elif backend_ok or frontend_ok:
        print("⚠️  일부 서비스만 배포 완료")
    else:
        print("⏳ 아직 배포 진행 중...")
        print("Render 대시보드에서 로그를 확인하세요: https://dashboard.render.com")

sys.exit(0)

