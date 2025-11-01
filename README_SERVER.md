# 🌐 서버 실행 안내

## ⚠️ 중요: MongoDB 필요

서버를 실행하려면 **MongoDB**가 필요합니다.

## 🚀 빠른 시작

### Docker Desktop 사용 (권장)

1. **Docker Desktop 실행** (macOS 앱에서)
2. **MongoDB 실행**:
```bash
docker run -d -p 27017:27017 --name mongodb mongo:7.0
```
3. **서버 시작**:
```bash
./setup-and-start.sh
```

### MongoDB 직접 설치

```bash
brew tap mongodb/brew
brew install mongodb-community
brew services start mongodb-community
./setup-and-start.sh
```

## 📱 접속 정보

### 로컬 접속
- Frontend: http://localhost:5173
- Backend: http://localhost:8000
- API Docs: http://localhost:8000/docs

## 🌐 인터넷에서 접속

### ngrok 사용

1. **설치**:
```bash
brew install ngrok/ngrok/ngrok
```

2. **계정 생성 및 인증**:
   - https://dashboard.ngrok.com/signup
   - 토큰 확인 후: `ngrok config add-authtoken YOUR_TOKEN`

3. **터널 생성**:
```bash
ngrok http 5173
```

터널 URL이 생성되면 어디서든 접속 가능!

## 📝 자세한 가이드

- `START_SERVER.md` - 서버 시작 상세 가이드
- `INTERNET_ACCESS.md` - 인터넷 접속 상세 가이드
