# 🚀 서버 시작 가이드

## 현재 상황

서버를 실행하려면 **MongoDB**가 필요합니다.

## 방법 1: Docker Desktop 사용 (가장 간단)

### 1단계: Docker Desktop 실행

1. macOS의 경우 Docker Desktop 앱을 실행
2. Docker가 실행 중인지 확인:
```bash
docker ps
```

### 2단계: MongoDB 실행

```bash
cd /Users/seungmin/Desktop/GODSAENG_PROJECT
docker run -d -p 27017:27017 --name mongodb mongo:7.0
```

### 3단계: 서버 시작

```bash
./setup-and-start.sh
```

## 방법 2: MongoDB 직접 설치

### 1단계: MongoDB 설치

```bash
brew tap mongodb/brew
brew install mongodb-community
brew services start mongodb-community
```

### 2단계: 서버 시작

```bash
./setup-and-start.sh
```

## 서버가 시작되면

### 로컬 접속
- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:8000
- **API Docs**: http://localhost:8000/docs

### 인터넷에서 접속 (ngrok)

1. **ngrok 설치**:
```bash
brew install ngrok/ngrok/ngrok
```

2. **ngrok 계정 생성 및 인증**:
   - https://dashboard.ngrok.com/signup 에서 계정 생성
   - https://dashboard.ngrok.com/get-started/your-authtoken 에서 토큰 확인
   - 인증:
```bash
ngrok config add-authtoken YOUR_TOKEN
```

3. **터널 생성**:
```bash
ngrok http 5173
```

터널 URL이 생성되면 어디서든 접속 가능합니다!

## 빠른 시작 (전체 과정)

### Docker 사용 시:

```bash
# 1. Docker Desktop 실행 (수동)

# 2. MongoDB 실행
cd /Users/seungmin/Desktop/GODSAENG_PROJECT
docker run -d -p 27017:27017 --name mongodb mongo:7.0

# 3. 서버 시작
./setup-and-start.sh

# 4. 새 터미널에서 ngrok 실행 (인터넷 접속용)
ngrok http 5173
```

### MongoDB 직접 설치 시:

```bash
# 1. MongoDB 설치 및 실행
brew tap mongodb/brew
brew install mongodb-community
brew services start mongodb-community

# 2. 서버 시작
cd /Users/seungmin/Desktop/GODSAENG_PROJECT
./setup-and-start.sh

# 3. 새 터미널에서 ngrok 실행 (인터넷 접속용)
ngrok http 5173
```

## 서버 관리

### 서버 상태 확인
```bash
curl http://localhost:8000/
curl http://localhost:5173/
```

### 서버 중지
```bash
kill $(cat .backend.pid) $(cat .frontend.pid)
```

### 로그 확인
```bash
tail -f backend.log frontend.log
```

## 문제 해결

### Docker 연결 오류
- Docker Desktop이 실행 중인지 확인
- Docker Desktop 재시작

### MongoDB 연결 오류
- MongoDB가 실행 중인지 확인:
```bash
# Docker 사용 시
docker ps | grep mongodb

# 로컬 설치 시
brew services list | grep mongodb
```

### 포트 충돌
```bash
# 포트 확인
lsof -i :8000
lsof -i :5173

# 프로세스 종료
kill -9 PID
```

## 현재 서버 상태

서버가 실행 중인지 확인:

```bash
cd /Users/seungmin/Desktop/GODSAENG_PROJECT
ps aux | grep -E "(uvicorn|vite)" | grep -v grep
```

## 다음 단계

1. ✅ MongoDB 설정
2. ✅ 서버 시작 (`./setup-and-start.sh`)
3. ✅ 로컬 접속 테스트
4. ✅ ngrok 설치 및 설정 (인터넷 접속)
5. ✅ 인터넷에서 접속 테스트

