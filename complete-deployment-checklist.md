# ✅ GODSAENG 배포 체크리스트

이 체크리스트를 따라 배포를 완료하세요!

## 📋 사전 준비 (완료 ✅)

- [x] Git 저장소 초기화
- [x] 모든 파일 커밋
- [x] 배포 설정 파일 생성
- [x] 배포 가이드 문서 작성

## 🚀 배포 단계

### 1️⃣ GitHub 저장소 (5분)

- [ ] GitHub 계정 로그인: https://github.com
- [ ] 새 저장소 생성: https://github.com/new
- [ ] 저장소 이름 입력 (예: `godsaeng-project`)
- [ ] Public 또는 Private 선택
- [ ] "Create repository" 클릭
- [ ] 명령어 실행:
  ```bash
  cd /Users/seungmin/Desktop/GODSAENG_PROJECT
  git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
  git push -u origin main
  ```
- [ ] GitHub에서 코드 확인

### 2️⃣ MongoDB Atlas (5분)

- [ ] MongoDB Atlas 계정 생성: https://www.mongodb.com/cloud/atlas/register
- [ ] 무료 클러스터 생성 (FREE M0)
- [ ] 클러스터 생성 대기 (약 5분)
- [ ] 데이터베이스 사용자 생성 (Username/Password 저장)
- [ ] 네트워크 접근 허용 (0.0.0.0/0)
- [ ] 연결 문자열 복사
- [ ] 연결 문자열에 데이터베이스 이름 추가 (`/godsaeng?`)

### 3️⃣ Render 백엔드 (5분)

- [ ] Render 계정 생성: https://dashboard.render.com (GitHub 로그인)
- [ ] "New +" → "Web Service" 클릭
- [ ] GitHub 저장소 연결
- [ ] 설정 입력:
  - Name: `godsaeng-backend`
  - Root Directory: `backend`
  - Environment: `Python 3`
  - Build Command: `pip install -r requirements.txt`
  - Start Command: `uvicorn main:app --host 0.0.0.0 --port $PORT`
- [ ] 환경 변수 입력:
  - MONGODB_URL (위에서 복사)
  - DATABASE_NAME=godsaeng
  - JWT_SECRET_KEY (32자 이상)
  - ACCESS_TOKEN_EXPIRE_MINUTES=30
  - AI_PROVIDER=huggingface
- [ ] "Create Web Service" 클릭
- [ ] 배포 완료 대기 (5-10분)
- [ ] 백엔드 URL 복사 (예: https://godsaeng-backend.onrender.com)

### 4️⃣ Render 프론트엔드 (5분)

- [ ] Render 대시보드에서 "New +" → "Static Site"
- [ ] 같은 GitHub 저장소 연결
- [ ] 설정 입력:
  - Name: `godsaeng-frontend`
  - Root Directory: `frontend`
  - Build Command: `npm install && npm run build`
  - Publish Directory: `dist`
- [ ] 환경 변수 입력:
  - VITE_API_BASE_URL=백엔드_URL
- [ ] "Create Static Site" 클릭
- [ ] 배포 완료 대기 (5-10분)

## 🎉 배포 완료

- [ ] 프론트엔드 URL 접속 확인
- [ ] 백엔드 API 접속 확인
- [ ] API 문서 접속 확인 (/docs)
- [ ] 회원가입 테스트
- [ ] 로그인 테스트
- [ ] 기록 작성 테스트
- [ ] AI 분석 테스트

## 📝 배포 정보 기록

배포 완료 후 아래 정보를 기록하세요:

```
백엔드 URL: https://___________________.onrender.com
프론트엔드 URL: https://___________________.onrender.com
MongoDB Atlas: cluster0.xxxxx.mongodb.net
배포 날짜: ____년 __월 __일
```

---

**체크리스트를 따라 단계별로 진행하세요!** ✅

