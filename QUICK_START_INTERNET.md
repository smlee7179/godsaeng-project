# 🌐 인터넷에서 접속하기 - 빠른 가이드

## 현재 상황

서버가 실행되고 있습니다. 이제 인터넷에서 접속할 수 있게 설정하세요.

## 🚀 가장 빠른 방법: ngrok

### 1. ngrok 설치

```bash
# macOS
brew install ngrok/ngrok/ngrok

# 또는 직접 다운로드
# https://ngrok.com/download
```

### 2. ngrok 계정 생성 및 인증

1. https://dashboard.ngrok.com/signup 에서 무료 계정 생성
2. https://dashboard.ngrok.com/get-started/your-authtoken 에서 토큰 확인
3. 인증:
```bash
ngrok config add-authtoken YOUR_TOKEN_HERE
```

### 3. 터널 생성

새 터미널 창을 열고:

```bash
cd /Users/seungmin/Desktop/GODSAENG_PROJECT

# 프론트엔드 접근 (포트 5173)
ngrok http 5173

# 또는 포트 80 (Docker 사용 시)
ngrok http 80
```

### 4. 접속 URL 확인

ngrok을 실행하면 다음과 같은 URL이 표시됩니다:

```
Forwarding   https://xxxx-xxxx-xxxx.ngrok-free.app -> http://localhost:5173
```

이 URL을 어디서든 사용할 수 있습니다!

## 📱 접속 정보

### 로컬 접속
- Frontend: http://localhost:5173
- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/docs

### 로컬 네트워크 접속
같은 Wi-Fi에 연결된 기기에서:
- Frontend: http://YOUR_IP:5173
- Backend API: http://YOUR_IP:8000

IP 주소 확인:
```bash
# macOS
ipconfig getifaddr en0

# 또는
ifconfig | grep "inet " | grep -v 127.0.0.1
```

### 인터넷 접속 (ngrok 사용)
ngrok URL을 사용:
- Frontend: https://xxxx-xxxx.ngrok-free.app

## 🛠️ 서버 관리

### 서버 상태 확인
```bash
# 백엔드 확인
curl http://localhost:8000/

# 프론트엔드 확인
curl http://localhost:5173/
```

### 서버 재시작
```bash
# 프로세스 찾기
ps aux | grep uvicorn
ps aux | grep vite

# 종료 후 재시작
./start-direct.sh
```

### 로그 확인
서버 로그는 터미널에 표시됩니다.

## ⚠️ MongoDB 필요

MongoDB가 실행 중이어야 합니다. 다음 중 하나를 사용하세요:

### 방법 1: Docker로 MongoDB 실행
```bash
# Docker Desktop 실행 후
docker run -d -p 27017:27017 --name mongodb mongo:7.0
```

### 방법 2: 로컬 MongoDB 설치
```bash
# macOS
brew tap mongodb/brew
brew install mongodb-community
brew services start mongodb-community
```

## 🔧 문제 해결

### 서버가 시작되지 않는 경우

1. **MongoDB 확인**:
```bash
# MongoDB 실행 확인
docker ps | grep mongodb
# 또는
pgrep mongod
```

2. **포트 확인**:
```bash
lsof -i :8000
lsof -i :5173
```

3. **의존성 확인**:
```bash
cd backend
source venv/bin/activate
pip install -r requirements.txt
```

### ngrok 오류

- ngrok 계정 인증 확인
- 인터넷 연결 확인
- ngrok 상태 페이지: http://localhost:4040

## 📝 다음 단계

1. ✅ 서버 실행 확인
2. ✅ ngrok 설치 및 설정
3. ✅ 인터넷 URL 획득
4. ✅ 다른 기기에서 테스트
5. ✅ 기능 테스트

## 💡 팁

- ngrok 무료 버전은 세션이 끊어지면 URL이 변경됩니다
- 영구적인 URL이 필요하면 ngrok 유료 플랜 또는 클라우드 배포 고려
- 보안을 위해 프로덕션 환경에서는 HTTPS 사용 권장

