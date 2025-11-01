# GODSAENG PROJECT

AI 기반 라이프 트래킹 웹 애플리케이션

[![Deploy](https://img.shields.io/badge/Deploy-Docker-blue)](./DEPLOYMENT.md)
[![Status](https://img.shields.io/badge/Status-Ready-green)](./DEPLOYMENT.md)

## 프로젝트 개요

GODSAENG은 사용자의 일상을 기록하고 AI가 분석 및 피드백을 제공하는 웹 애플리케이션입니다.

## 🚀 빠른 시작

### Docker Compose로 실행 (권장)

```bash
# 배포 스크립트 실행
./deploy.sh

# 또는 수동 실행
docker-compose up -d
```

서비스 접속:
- **Frontend**: http://localhost
- **Backend API**: http://localhost:8000
- **API 문서**: http://localhost:8000/docs

자세한 배포 가이드는 [DEPLOYMENT.md](./DEPLOYMENT.md)를 참고하세요.

### 주요 기능

- 📝 **라이프 기록**: 일상 활동을 텍스트, 사진, 태그와 함께 기록
- 🤖 **AI 분석**: OpenAI API를 활용한 일상 요약 및 피드백
- 📊 **대시보드**: 기록 통계 및 최근 기록 확인
- 🔐 **사용자 인증**: JWT 기반 안전한 인증 시스템

## 기술 스택

- **Backend**: FastAPI, Python, MongoDB (Motor)
- **Frontend**: React, Vite, React Router
- **Database**: MongoDB
- **AI**: OpenAI GPT API (선택사항)

## 프로젝트 구조

```
GODSAENG_PROJECT/
├── backend/              # FastAPI 백엔드
│   ├── app/
│   │   ├── routers/      # API 라우터
│   │   ├── models/       # 데이터 모델
│   │   ├── services/     # 비즈니스 로직
│   │   ├── utils/        # 유틸리티 함수
│   │   └── config/       # 설정 파일
│   ├── config/           # 백엔드 설정
│   ├── main.py           # 애플리케이션 진입점
│   └── requirements.txt  # Python 의존성
├── frontend/             # React 프론트엔드
│   ├── src/
│   │   ├── components/   # 재사용 컴포넌트
│   │   ├── pages/        # 페이지 컴포넌트
│   │   ├── contexts/     # React Context
│   │   └── utils/        # 유틸리티 함수
│   └── package.json      # Node.js 의존성
└── database/             # 데이터베이스 스키마
```

## 시작하기

### 사전 요구사항

- Python 3.8+
- Node.js 16+
- MongoDB (로컬 또는 원격)

### 백엔드 설정

1. 백엔드 디렉토리로 이동:
```bash
cd backend
```

2. 가상 환경 생성 및 활성화:
```bash
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
```

3. 의존성 설치:
```bash
pip install -r requirements.txt
```

4. 설정 파일 생성:
```bash
# backend/config/secrets.json에 필요한 키 추가
{
  "JWT_SECRET_KEY": "your-secret-key-change-in-production",
  "OPENAI_API_KEY": "your-openai-api-key"  # 선택사항
}
```

5. 환경 변수 설정 (선택사항):
```bash
# .env 파일 생성
cp .env.example .env
# .env 파일을 편집하여 MongoDB URL 등을 설정
```

6. MongoDB 실행 및 연결 확인

7. 서버 실행:
```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### 프론트엔드 설정

1. 프론트엔드 디렉토리로 이동:
```bash
cd frontend
```

2. 의존성 설치:
```bash
npm install
```

3. 개발 서버 실행:
```bash
npm run dev
```

프론트엔드는 http://localhost:5173 에서 실행됩니다.

## API 문서

백엔드 서버 실행 후 다음 주소에서 API 문서를 확인할 수 있습니다:

- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## 주요 API 엔드포인트

### 인증
- `POST /api/auth/register` - 회원가입
- `POST /api/auth/login-json` - 로그인
- `GET /api/auth/me` - 현재 사용자 정보

### 라이프 기록
- `GET /api/logs` - 기록 목록 조회
- `POST /api/logs` - 새 기록 생성
- `GET /api/logs/{id}` - 기록 상세 조회
- `PUT /api/logs/{id}` - 기록 수정
- `DELETE /api/logs/{id}` - 기록 삭제
- `GET /api/logs/today` - 오늘의 기록 조회

### AI 분석
- `POST /api/ai/analyze` - AI 분석 생성
- `GET /api/ai/report` - 특정 날짜 리포트 조회
- `GET /api/ai/reports` - 리포트 목록 조회

## AI API 설정 (무료 옵션 사용 가능!)

GODSAENG은 여러 무료 AI API를 지원합니다:

### 빠른 설정 (Hugging Face - 무료)

`.env` 파일에 다음 추가:
```env
AI_PROVIDER=huggingface
```

API 키 없이도 사용 가능합니다! (제한적)

### 더 나은 성능 (API 키 발급)

1. **Hugging Face** (권장 - 무료):
   - 계정 생성: https://huggingface.co/join
   - API 키 발급: https://huggingface.co/settings/tokens
   - `.env` 파일에 추가:
   ```env
   AI_PROVIDER=huggingface
   HUGGINGFACE_API_KEY=hf_your_key_here
   ```

2. **Google Gemini** (무료 티어):
   - API 키 발급: https://makersuite.google.com/app/apikey
   - `.env` 파일에 추가:
   ```env
   AI_PROVIDER=gemini
   GEMINI_API_KEY=your_key_here
   ```

3. **Ollama** (로컬 실행 - 완전 무료):
   - 설치: https://ollama.ai
   - 모델 다운로드: `ollama pull llama3`
   - `.env` 파일에 추가:
   ```env
   AI_PROVIDER=ollama
   ```

자세한 설정 가이드는 [AI_SETUP.md](./AI_SETUP.md)를 참고하세요.

API 키가 없어도 기본 기능은 정상적으로 사용할 수 있습니다.

## 개발 가이드

### 백엔드 개발

- 모든 주석은 한국어로 작성
- 새로운 라우터는 `app/routers/`에 추가
- 모델은 `app/models/`에 정의
- 비즈니스 로직은 `app/services/`에 구현

### 프론트엔드 개발

- 컴포넌트는 `src/components/`에 재사용 가능한 컴포넌트
- 페이지는 `src/pages/`에 추가
- API 호출은 `src/utils/api.js`를 통해 진행

## 배포

프로젝트는 Docker Compose를 사용하여 쉽게 배포할 수 있습니다.

### 빠른 배포

```bash
./deploy.sh
```

### 수동 배포

```bash
# 환경 변수 설정
cp .env.example .env
# .env 파일 편집

# Docker Compose 실행
docker-compose up -d
```

자세한 배포 가이드는 [DEPLOYMENT.md](./DEPLOYMENT.md)를 참고하세요.

## 프로젝트 구조

```
GODSAENG_PROJECT/
├── backend/              # FastAPI 백엔드
│   ├── app/             # 애플리케이션 코드
│   ├── config/          # 설정 파일
│   ├── Dockerfile       # 백엔드 Docker 이미지
│   ├── main.py          # 애플리케이션 진입점
│   └── requirements.txt # Python 의존성
├── frontend/            # React 프론트엔드
│   ├── src/            # 소스 코드
│   ├── Dockerfile      # 프론트엔드 Docker 이미지
│   └── package.json    # Node.js 의존성
├── database/            # 데이터베이스 스키마
├── docker-compose.yml   # Docker Compose 설정
├── deploy.sh            # 배포 스크립트
└── Makefile            # 유용한 명령어 모음
```

## 라이선스

이 프로젝트는 개인 프로젝트입니다.
