# 🚀 GODSAENG PROJECT 배포 가이드

## 빠른 시작 (Docker Compose)

가장 간단한 방법으로 프로젝트를 실행할 수 있습니다.

### 1. 프로젝트 클론/다운로드

```bash
cd GODSAENG_PROJECT
```

### 2. 배포 스크립트 실행

```bash
# 배포 스크립트 실행 (권한 부여 필요)
chmod +x deploy.sh
./deploy.sh
```

또는 수동으로:

```bash
# 환경 변수 파일 생성
cp .env.example .env

# secrets.json 파일 생성
mkdir -p backend/config
echo '{"JWT_SECRET_KEY": "your-secret-key", "OPENAI_API_KEY": ""}' > backend/config/secrets.json

# Docker Compose로 실행
docker-compose up -d
```

### 3. 서비스 접속

- **Frontend**: http://localhost
- **Backend API**: http://localhost:8000
- **API 문서**: http://localhost:8000/docs

### 4. 서비스 관리

```bash
# 서비스 중지
docker-compose down

# 서비스 재시작
docker-compose restart

# 로그 확인
docker-compose logs -f

# 모든 컨테이너 및 데이터 삭제
docker-compose down -v
```

## Makefile 사용 (선택사항)

```bash
# 초기 설정
make setup

# 서비스 시작
make up

# 서비스 중지
make down

# 로그 확인
make logs

# 완전 정리
make clean
```

## 환경 변수 설정

### .env 파일

프로젝트 루트에 `.env` 파일을 생성하고 다음 내용을 추가:

```env
JWT_SECRET_KEY=your-super-secret-jwt-key-change-in-production
OPENAI_API_KEY=your-openai-api-key  # 선택사항
```

### backend/config/secrets.json

```json
{
  "JWT_SECRET_KEY": "your-super-secret-jwt-key",
  "OPENAI_API_KEY": "sk-..."  # 선택사항
}
```

⚠️ **보안 주의**: 프로덕션 환경에서는 반드시 강력한 시크릿 키를 사용하세요!

## 클라우드 배포

### Railway 배포

1. GitHub에 프로젝트 푸시
2. Railway 계정 생성 및 연결: https://railway.app
3. New Project > Deploy from GitHub repo 선택
4. 환경 변수 설정:
   - `MONGODB_URL` (Railway MongoDB 서비스 사용)
   - `JWT_SECRET_KEY`
   - `OPENAI_API_KEY` (선택사항)
5. Build Command: `cd backend && pip install -r requirements.txt`
6. Start Command: `cd backend && uvicorn main:app --host 0.0.0.0 --port $PORT`

### Render 배포

1. GitHub에 프로젝트 푸시
2. Render 계정 생성: https://render.com
3. New Web Service 선택
4. GitHub 레포지토리 연결
5. 환경 설정:
   - Build Command: `cd backend && pip install -r requirements.txt`
   - Start Command: `cd backend && uvicorn main:app --host 0.0.0.0 --port $PORT`
   - 환경 변수 추가:
     - `MONGODB_URL`
     - `JWT_SECRET_KEY`
     - `OPENAI_API_KEY`

### Docker Hub 배포

```bash
# 이미지 빌드
docker build -t yourusername/godsaeng-backend ./backend
docker build -t yourusername/godsaeng-frontend ./frontend

# Docker Hub에 푸시
docker push yourusername/godsaeng-backend
docker push yourusername/godsaeng-frontend
```

## 수동 배포

### 백엔드 수동 배포

```bash
cd backend

# 가상 환경 생성
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# 의존성 설치
pip install -r requirements.txt

# 환경 변수 설정
export MONGODB_URL=mongodb://localhost:27017
export JWT_SECRET_KEY=your-secret-key
export OPENAI_API_KEY=your-api-key

# 서버 실행
uvicorn main:app --host 0.0.0.0 --port 8000
```

### 프론트엔드 수동 배포

```bash
cd frontend

# 의존성 설치
npm install

# 프로덕션 빌드
npm run build

# 빌드된 파일은 dist/ 디렉토리에 생성됩니다
# Nginx, Apache 등의 웹 서버로 서빙하거나
# 정적 파일 호스팅 서비스에 업로드
```

## 프로덕션 환경 설정

### 보안 설정

1. **강력한 JWT 시크릿 키 사용**
   ```bash
   # 랜덤 키 생성
   openssl rand -hex 32
   ```

2. **HTTPS 설정**
   - Nginx 또는 클라우드 로드밸런서 사용
   - Let's Encrypt로 SSL 인증서 발급

3. **환경 변수 보호**
   - 민감한 정보는 환경 변수로 관리
   - `.env` 파일은 Git에 커밋하지 않기

### 성능 최적화

1. **백엔드**
   - Gunicorn + Uvicorn 워커 사용:
     ```bash
     gunicorn main:app -w 4 -k uvicorn.workers.UvicornWorker
     ```

2. **프론트엔드**
   - Nginx로 정적 파일 서빙
   - Gzip 압축 활성화 (이미 nginx.conf에 포함)

3. **데이터베이스**
   - MongoDB 인덱스 최적화 (이미 구현됨)
   - 연결 풀 설정

## 문제 해결

### 포트 충돌

포트 80, 8000이 이미 사용 중인 경우:

```yaml
# docker-compose.yml 수정
ports:
  - "8080:80"      # 프론트엔드
  - "8001:8000"    # 백엔드
```

### MongoDB 연결 오류

1. MongoDB 컨테이너가 실행 중인지 확인:
   ```bash
   docker-compose ps
   ```

2. 연결 URL 확인:
   - Docker Compose: `mongodb://mongodb:27017`
   - 로컬: `mongodb://localhost:27017`

### API 연결 오류

1. 프론트엔드에서 백엔드 API URL 확인
2. CORS 설정 확인 (이미 설정됨)
3. 네트워크 연결 확인

## 모니터링

### 로그 확인

```bash
# 모든 서비스 로그
docker-compose logs -f

# 특정 서비스 로그
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f mongodb
```

### 헬스 체크

```bash
# 서비스 상태 확인
docker-compose ps

# API 헬스 체크
curl http://localhost:8000/

# API 문서 접속
open http://localhost:8000/docs
```

## 지원

문제가 발생하면 다음을 확인하세요:

1. Docker와 Docker Compose가 설치되어 있는지
2. 포트가 사용 가능한지
3. 환경 변수가 올바르게 설정되었는지
4. 로그를 확인하여 오류 메시지 확인

