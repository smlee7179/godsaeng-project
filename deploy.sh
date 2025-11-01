#!/bin/bash

# GODSAENG PROJECT 배포 스크립트

set -e

echo "🚀 GODSAENG PROJECT 배포 시작..."

# .env 파일 확인
if [ ! -f .env ]; then
    echo "⚠️  .env 파일이 없습니다. .env.example을 복사합니다..."
    cp .env.example .env
    echo "✅ .env 파일을 생성했습니다. 필요한 값들을 설정해주세요."
fi

# secrets.json 파일 확인
if [ ! -f backend/config/secrets.json ]; then
    echo "⚠️  secrets.json 파일이 없습니다. 기본 파일을 생성합니다..."
    mkdir -p backend/config
    echo '{"JWT_SECRET_KEY": "", "OPENAI_API_KEY": ""}' > backend/config/secrets.json
    echo "✅ secrets.json 파일을 생성했습니다."
fi

# Docker 설치 확인
if ! command -v docker &> /dev/null; then
    echo "❌ Docker가 설치되어 있지 않습니다."
    echo "Docker를 설치해주세요: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose가 설치되어 있지 않습니다."
    echo "Docker Compose를 설치해주세요: https://docs.docker.com/compose/install/"
    exit 1
fi

echo "📦 Docker 이미지 빌드 중..."
docker-compose build

echo "🚀 서비스 시작 중..."
docker-compose up -d

echo "⏳ 서비스 시작 대기 중..."
sleep 10

# 헬스 체크
echo "🔍 서비스 상태 확인 중..."
if docker-compose ps | grep -q "Up"; then
    echo ""
    echo "✅ 배포 완료!"
    echo ""
    echo "📝 서비스 정보:"
    echo "   - Frontend: http://localhost"
    echo "   - Backend API: http://localhost:8000"
    echo "   - API Docs: http://localhost:8000/docs"
    echo ""
    echo "📊 서비스 상태 확인:"
    docker-compose ps
    echo ""
    echo "📋 로그 확인: make logs"
else
    echo "❌ 서비스 시작에 문제가 있습니다."
    echo "로그를 확인해주세요: docker-compose logs"
    exit 1
fi

