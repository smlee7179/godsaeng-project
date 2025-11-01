# GODSAENG PROJECT 설치 및 실행 가이드

## 빠른 시작

### 1. MongoDB 설치 및 실행

#### macOS (Homebrew)
```bash
brew tap mongodb/brew
brew install mongodb-community
brew services start mongodb-community
```

#### Windows
MongoDB 공식 웹사이트에서 설치: https://www.mongodb.com/try/download/community

#### Linux
```bash
# Ubuntu/Debian
sudo apt-get install mongodb

# 또는 Docker 사용
docker run -d -p 27017:27017 --name mongodb mongo
```

### 2. 백엔드 설정

```bash
cd backend

# 가상 환경 생성
python -m venv venv

# 가상 환경 활성화
# macOS/Linux:
source venv/bin/activate
# Windows:
venv\Scripts\activate

# 의존성 설치
pip install -r requirements.txt

# secrets.json 파일 생성
echo '{
  "JWT_SECRET_KEY": "your-secret-key-change-in-production",
  "OPENAI_API_KEY": ""
}' > config/secrets.json

# 서버 실행
uvicorn main:app --reload --port 8000
```

### 3. 프론트엔드 설정

```bash
cd frontend

# 의존성 설치
npm install

# 개발 서버 실행
npm run dev
```

## 환경 변수 설정

### 백엔드 (.env 파일)

`backend/.env` 파일을 생성하고 다음 내용을 추가:

```env
MONGODB_URL=mongodb://localhost:27017
DATABASE_NAME=godsaeng
JWT_SECRET_KEY=your-secret-key-change-in-production
ACCESS_TOKEN_EXPIRE_MINUTES=30
OPENAI_API_KEY=your-openai-api-key  # 선택사항
ENVIRONMENT=development
```

### 프론트엔드 환경 변수

`frontend/.env` 파일을 생성 (선택사항):

```env
VITE_API_BASE_URL=http://localhost:8000
```

## 문제 해결

### MongoDB 연결 오류

- MongoDB가 실행 중인지 확인:
  ```bash
  # macOS/Linux
  brew services list
  # 또는
  ps aux | grep mongod
  
  # Windows
  net start MongoDB
  ```

- 연결 URL 확인: `mongodb://localhost:27017`

### 포트 충돌

- 백엔드 기본 포트: 8000
- 프론트엔드 기본 포트: 5173
- 포트 변경:
  - 백엔드: `uvicorn main:app --port 8001`
  - 프론트엔드: `vite.config.js`에서 `server.port` 수정

### OpenAI API 오류

- API 키가 올바른지 확인
- `backend/config/secrets.json`에 `OPENAI_API_KEY`가 설정되어 있는지 확인
- API 키가 없어도 다른 기능은 정상 작동합니다

## 프로덕션 배포

### 백엔드

1. 환경 변수 설정:
   - `ENVIRONMENT=production`
   - 강력한 `JWT_SECRET_KEY` 사용
   - MongoDB 프로덕션 URL 사용

2. 서버 실행:
```bash
uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4
```

또는 Gunicorn 사용:
```bash
gunicorn main:app -w 4 -k uvicorn.workers.UvicornWorker -b 0.0.0.0:8000
```

### 프론트엔드

1. 빌드:
```bash
cd frontend
npm run build
```

2. 빌드된 파일 배포:
   - `dist/` 디렉토리를 정적 파일 서버에 배포
   - Nginx, Apache 등 사용

## 추가 리소스

- FastAPI 문서: https://fastapi.tiangolo.com/
- React 문서: https://react.dev/
- MongoDB 문서: https://docs.mongodb.com/

