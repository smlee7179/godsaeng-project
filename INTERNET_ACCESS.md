# 🌐 인터넷에서 접속 가능하게 설정하기

GODSAENG 프로젝트를 인터넷 어디서나 접속 가능하게 만드는 방법입니다.

## 방법 1: ngrok 사용 (가장 간단)

### 1단계: ngrok 설치

**macOS**:
```bash
brew install ngrok/ngrok/ngrok
```

**또는 직접 다운로드**: https://ngrok.com/download

### 2단계: ngrok 계정 생성 및 인증

1. https://dashboard.ngrok.com/signup 에서 무료 계정 생성
2. https://dashboard.ngrok.com/get-started/your-authtoken 에서 인증 토큰 확인
3. 인증:
```bash
ngrok config add-authtoken YOUR_TOKEN
```

### 3단계: 서버 실행

#### Docker 사용 시:
```bash
./start-server.sh
```

#### 직접 실행 시:
```bash
./start-direct.sh
```

### 4단계: ngrok 터널 생성

```bash
# 프론트엔드 접근 (포트 80 또는 5173)
ngrok http 80

# 또는 백엔드만 접근
ngrok http 8000
```

터널 URL이 생성되면 어디서든 접속 가능합니다!

## 방법 2: 클라우드 배포 (영구적)

### Railway (권장 - 간단하고 무료 티어)

1. GitHub에 프로젝트 푸시
2. https://railway.app 접속 및 GitHub 연결
3. New Project > Deploy from GitHub repo
4. 환경 변수 설정:
   - `MONGODB_URL` (Railway MongoDB 서비스 사용)
   - `JWT_SECRET_KEY`
   - `HUGGINGFACE_API_KEY`
   - `AI_PROVIDER=huggingface`
5. 배포 완료! 자동으로 URL 제공

### Render (무료 티어)

1. GitHub에 프로젝트 푸시
2. https://render.com 접속
3. New > Web Service
4. GitHub 레포지토리 연결
5. 빌드 설정:
   - Build Command: `cd backend && pip install -r requirements.txt`
   - Start Command: `cd backend && uvicorn main:app --host 0.0.0.0 --port $PORT`
6. 환경 변수 설정
7. 배포 완료!

## 방법 3: 로컬 네트워크 접속

같은 네트워크(Wi-Fi)에 있는 다른 기기에서 접속:

### 서버 IP 주소 확인

**macOS/Linux**:
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

**또는**:
```bash
ipconfig getifaddr en0  # macOS
hostname -I              # Linux
```

### 접속

- Frontend: `http://YOUR_IP:5173` 또는 `http://YOUR_IP`
- Backend API: `http://YOUR_IP:8000`

## 현재 서버 상태 확인

```bash
# 서버가 실행 중인지 확인
curl http://localhost:8000/

# 또는
curl http://localhost:80/
```

## 포트 포워딩 (라우터 설정)

집/사무실 네트워크에서 인터넷 접속을 원하는 경우:

1. 라우터 관리 페이지 접속 (보통 `192.168.1.1` 또는 `192.168.0.1`)
2. 포트 포워딩 설정
3. 외부 포트 80 → 내부 IP:80
4. 외부 포트 8000 → 내부 IP:8000
5. 공인 IP로 접속 가능

⚠️ **보안 주의**: 포트 포워딩 시 방화벽 설정 확인!

## 빠른 시작

### 1. Docker 사용 (권장)

```bash
# Docker Desktop 실행 확인
# 서버 시작
./start-server.sh

# ngrok 터널 생성 (새 터미널)
ngrok http 80
```

### 2. 직접 실행

```bash
# MongoDB 실행 확인
docker run -d -p 27017:27017 --name mongodb mongo:7.0

# 서버 시작
./start-direct.sh

# ngrok 터널 생성 (새 터미널)
ngrok http 5173
```

## 문제 해결

### 포트가 이미 사용 중인 경우

```bash
# 포트 사용 확인
lsof -i :80
lsof -i :8000
lsof -i :5173

# 프로세스 종료
kill -9 PID
```

### 방화벽 문제

**macOS**:
```bash
# 방화벽 설정 확인
System Preferences > Security & Privacy > Firewall
```

**Linux**:
```bash
# 방화벽 포트 열기
sudo ufw allow 80
sudo ufw allow 8000
sudo ufw allow 5173
```

### ngrok 연결 오류

1. ngrok 계정 인증 확인
2. 인터넷 연결 확인
3. ngrok 상태 확인: http://localhost:4040

## 보안 권장사항

1. **프로덕션 환경**에서는 HTTPS 사용 (Let's Encrypt)
2. **JWT 시크릿 키**를 강력하게 설정
3. **환경 변수**에 민감한 정보 저장 (`.env` 파일)
4. **방화벽** 설정으로 불필요한 포트 차단
5. **정기적인 업데이트** 및 보안 패치

