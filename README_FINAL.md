# 🚀 GODSAENG 서버 실행 완료!

## ✅ 완료된 작업

1. ✅ 백엔드 서버 시작 (포트 8000)
2. ✅ 프론트엔드 서버 시작 (포트 5173)
3. ✅ ngrok 설치 완료
4. ✅ 서버 관리 스크립트 생성

## 📝 접속 정보

### 로컬 접속
- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:8000
- **API 문서**: http://localhost:8000/docs

### 로컬 네트워크 접속 (같은 Wi-Fi)
- **Frontend**: http://172.30.1.53:5173
- **Backend API**: http://172.30.1.53:8000

## 🌐 인터넷 접속 설정 (ngrok)

### 1단계: ngrok 계정 생성
1. https://dashboard.ngrok.com/signup 에서 무료 계정 생성

### 2단계: 인증 토큰 확인
1. https://dashboard.ngrok.com/get-started/your-authtoken 에서 토큰 확인

### 3단계: ngrok 인증
```bash
cd /Users/seungmin/Desktop/GODSAENG_PROJECT
ngrok config add-authtoken YOUR_TOKEN_HERE
```

### 4단계: 터널 생성
```bash
./start-ngrok-tunnel.sh
```

터널 URL이 생성되면 어디서든 접속 가능합니다!

## 📊 서버 관리

### 상태 확인
```bash
./server-status.sh
```

### 서버 중지
```bash
kill $(cat .backend.pid) $(cat .frontend.pid)
```

### 로그 확인
```bash
tail -f backend.log frontend.log
```

### 서버 재시작
```bash
./setup-and-start.sh
```

## ⚠️ 참고사항

- MongoDB가 실행 중이어야 모든 기능이 작동합니다
- ngrok 무료 버전은 세션이 끊어지면 URL이 변경됩니다
- 영구적인 URL이 필요하면 ngrok 유료 플랜 또는 클라우드 배포를 고려하세요

## 🎉 다음 단계

1. 웹 브라우저에서 http://localhost:5173 접속
2. 회원가입 및 로그인 테스트
3. 기록 작성 및 AI 분석 테스트
4. ngrok으로 인터넷 접속 설정

