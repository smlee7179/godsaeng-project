#!/usr/bin/env python3
"""
Render 자동 배포 스크립트 (브라우저 자동화)
"""

import sys
import time
from pathlib import Path

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🚀 Render 자동 배포 (브라우저 자동화)")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("")

# MongoDB 연결 문자열 읽기
env_atlas = Path(".env.atlas")
if env_atlas.exists():
    mongodb_url = None
    with open(env_atlas) as f:
        for line in f:
            if line.startswith("MONGODB_URL="):
                mongodb_url = line.split("=", 1)[1].strip()
                break
    
    if mongodb_url:
        print("✅ MongoDB 연결 문자열 확인:")
        print(f"   {mongodb_url[:50]}...")
        print("")
    else:
        print("❌ MongoDB 연결 문자열을 찾을 수 없습니다.")
        sys.exit(1)
else:
    print("❌ .env.atlas 파일을 찾을 수 없습니다.")
    sys.exit(1)

print("⚠️  브라우저 자동화를 위해서는 다음이 필요합니다:")
print("   1. Render 계정 로그인 정보")
print("   2. GitHub OAuth 인증")
print("   3. 브라우저 자동화 도구 설치")
print("")
print("현재 환경에서는 브라우저 자동화가 제한적입니다.")
print("")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("📋 대신 다음 방법을 사용하세요:")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("")
print("1️⃣  Render 대시보드 접속:")
print("   https://dashboard.render.com/new/blueprint-spec")
print("")
print("2️⃣  GitHub 저장소 입력:")
print("   smlee7179/godsaeng-project")
print("")
print("3️⃣  'Apply' 클릭")
print("")
print("4️⃣  환경 변수 추가:")
print("   MONGODB_URL = (아래 값 복사)")
print(f"   {mongodb_url}")
print("")
print("5️⃣  다시 'Apply' 클릭")
print("")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("")
print("브라우저 자동화는 보안상의 이유로 직접 로그인해야 합니다.")
print("위 단계를 따라하면 2분 안에 배포가 완료됩니다!")
print("")

# 브라우저 열기 시도
import subprocess
import platform

render_url = "https://dashboard.render.com/new/blueprint-spec"

print("🔗 Render 배포 페이지를 엽니다...")
print("")

try:
    if platform.system() == "Darwin":  # macOS
        subprocess.run(["open", render_url])
        print("✅ 브라우저가 열렸습니다!")
        print("")
        print("위 단계를 따라 배포를 완료하세요!")
    elif platform.system() == "Windows":
        subprocess.run(["start", render_url], shell=True)
        print("✅ 브라우저가 열렸습니다!")
    else:
        subprocess.run(["xdg-open", render_url])
        print("✅ 브라우저가 열렸습니다!")
except Exception as e:
    print(f"⚠️  브라우저를 자동으로 열 수 없습니다: {e}")
    print(f"수동으로 다음 URL을 열어주세요: {render_url}")

print("")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("📋 MongoDB 연결 문자열 (클립보드에 복사):")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print(f"{mongodb_url}")
print("")
print("이 값을 복사하여 Render 환경 변수에 붙여넣으세요!")
print("")

# 클립보드에 복사 시도
try:
    if platform.system() == "Darwin":  # macOS
        subprocess.run(["pbcopy"], input=mongodb_url.encode(), check=True)
        print("✅ MongoDB 연결 문자열이 클립보드에 복사되었습니다!")
        print("   (Cmd+V로 붙여넣으세요)")
    elif platform.system() == "Linux":
        try:
            subprocess.run(["xclip", "-selection", "clipboard"], input=mongodb_url.encode(), check=True)
            print("✅ MongoDB 연결 문자열이 클립보드에 복사되었습니다!")
        except:
            print("⚠️  xclip이 설치되어 있지 않습니다. 수동으로 복사하세요.")
except Exception as e:
    print("⚠️  클립보드 복사 실패: 수동으로 복사하세요.")

sys.exit(0)

