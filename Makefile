.PHONY: help build up down restart logs clean dev-backend dev-frontend setup

help:
	@echo "GODSAENG PROJECT - 사용 가능한 명령어:"
	@echo "  make setup          - 프로젝트 초기 설정"
	@echo "  make build          - Docker 이미지 빌드"
	@echo "  make up             - 서비스 시작"
	@echo "  make down           - 서비스 중지"
	@echo "  make restart        - 서비스 재시작"
	@echo "  make logs           - 로그 확인"
	@echo "  make clean          - 모든 컨테이너 및 볼륨 삭제"
	@echo "  make dev-backend    - 백엔드 개발 서버 실행"
	@echo "  make dev-frontend   - 프론트엔드 개발 서버 실행"

setup:
	@echo "프로젝트 초기 설정 중..."
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo ".env 파일이 생성되었습니다. 필요한 값들을 설정해주세요."; \
	fi
	@if [ ! -f backend/config/secrets.json ]; then \
		mkdir -p backend/config; \
		echo '{"JWT_SECRET_KEY": "", "OPENAI_API_KEY": ""}' > backend/config/secrets.json; \
		echo "backend/config/secrets.json 파일이 생성되었습니다."; \
	fi
	@echo "설정 완료!"

build:
	@echo "Docker 이미지 빌드 중..."
	docker-compose build

up:
	@echo "서비스 시작 중..."
	docker-compose up -d
	@echo "서비스가 시작되었습니다!"
	@echo "Frontend: http://localhost"
	@echo "Backend API: http://localhost:8000"
	@echo "API Docs: http://localhost:8000/docs"

down:
	@echo "서비스 중지 중..."
	docker-compose down

restart:
	@echo "서비스 재시작 중..."
	docker-compose restart

logs:
	docker-compose logs -f

clean:
	@echo "정리 중..."
	docker-compose down -v
	@echo "정리 완료!"

dev-backend:
	@echo "백엔드 개발 서버 실행 중..."
	cd backend && python -m venv venv || true
	cd backend && source venv/bin/activate && pip install -r requirements.txt
	cd backend && source venv/bin/activate && uvicorn main:app --reload --host 0.0.0.0 --port 8000

dev-frontend:
	@echo "프론트엔드 개발 서버 실행 중..."
	cd frontend && npm install
	cd frontend && npm run dev

