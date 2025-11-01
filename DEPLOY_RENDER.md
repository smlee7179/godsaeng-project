# 🚀 Render 클라우드 배포 가이드

이 가이드는 GODSAENG 프로젝트를 Render 무료 플랫폼에 배포하는 방법을 설명합니다.

## 📋 사전 준비

1. **Render 계정 생성**
   - https://render.com 에서 GitHub 계정으로 가입

2. **GitHub 저장소**
   - 프로젝트를 GitHub에 푸시해야 합니다

## 🗄️ 1단계: MongoDB Atlas 설정 (무료)

### 1.1 MongoDB Atlas 계정 생성
1. https://www.mongodb.com/cloud/atlas/register 접속
2. 무료 계정 생성 (M0 Free Tier)

### 1.2 클러스터 생성
1. "Create a Deployment" 클릭
2. **FREE** (M0) 선택
3. 클라우드 제공자: AWS
4. 리전: 가장 가까운 지역 (예: N. Virginia)
5. "Create Cluster" 클릭 (5분 소요)

### 1.3 데이터베이스 접근 설정
1. "Database Access" → "Add New Database User"
2. Username/Password 설정
3. User Privileges: "Atlas admin"
4. "Add User" 클릭

### 1.4 네트워크 접근 설정
1. "Network Access" → "Add IP Address"
2. **"Allow Access from Anywhere"** 선택 (0.0.0.0/0)
3. "Confirm" 클릭

### 1.5 연결 문자열 가져오기
1. "Database" → "Connect" 클릭
2. "Connect your application" 선택
3. Driver: Python, Version: 3.6 or later
4. **연결 문자열 복사** (예: `mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority`)
5. 데이터베이스 이름을 추가: `mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/godsaeng?retryWrites=true&w=majority`

## 🌐 2단계: Render 배포

### 2.1 백엔드 배포
1. Render 대시보드 → "New +" → "Web Service"
2. GitHub 저장소 연결
3. 설정:
   - **Name**: `godsaeng-backend`
   - **Root Directory**: `backend`
   - **Environment**: `Python 3`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `uvicorn main:app --host 0.0.0.0 --port $PORT`
4. 환경 변수 설정:
   ```
   MONGODB_URL=mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/godsaeng?retryWrites=true&w=majority
   DATABASE_NAME=godsaeng
   JWT_SECRET_KEY=your-super-secret-jwt-key-change-in-production
   ACCESS_TOKEN_EXPIRE_MINUTES=30
   AI_PROVIDER=huggingface
   HUGGINGFACE_API_KEY=your-huggingface-key-optional
   GEMINI_API_KEY=your-gemini-key-optional
   ```
5. "Create Web Service" 클릭

### 2.2 프론트엔드 배포
1. Render 대시보드 → "New +" → "Static Site"
2. GitHub 저장소 연결
3. 설정:
   - **Name**: `godsaeng-frontend`
   - **Root Directory**: `frontend`
   - **Build Command**: `npm install && npm run build`
   - **Publish Directory**: `dist`
4. 환경 변수 설정:
   ```
   VITE_API_BASE_URL=https://godsaeng-backend.onrender.com
   ```
5. "Create Static Site" 클릭

## 📝 3단계: 환경 변수 설정

### 백엔드 환경 변수 (Render Dashboard → godsaeng-backend → Environment)

| 키 | 값 | 설명 |
|---|---|---|
| `MONGODB_URL` | MongoDB Atlas 연결 문자열 | 필수 |
| `DATABASE_NAME` | `godsaeng` | 필수 |
| `JWT_SECRET_KEY` | 임의의 긴 문자열 | 필수 (보안) |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | `30` | 선택 |
| `AI_PROVIDER` | `huggingface` | 선택 |
| `HUGGINGFACE_API_KEY` | Hugging Face API 키 | 선택 |
| `GEMINI_API_KEY` | Gemini API 키 | 선택 |

### 프론트엔드 환경 변수 (Render Dashboard → godsaeng-frontend → Environment)

| 키 | 값 | 설명 |
|---|---|---|
| `VITE_API_BASE_URL` | `https://godsaeng-backend.onrender.com` | 백엔드 URL (자동 생성) |

## 🔄 4단계: 자동 배포 설정

Render는 GitHub에 푸시할 때마다 자동으로 배포됩니다:

1. 코드 변경 후:
   ```bash
   git add .
   git commit -m "Update code"
   git push origin main
   ```
2. Render가 자동으로 배포 시작

## 🌍 5단계: 접속 확인

배포 완료 후 (5-10분 소요):

1. **백엔드**: `https://godsaeng-backend.onrender.com`
2. **API 문서**: `https://godsaeng-backend.onrender.com/docs`
3. **프론트엔드**: `https://godsaeng-frontend.onrender.com`

## ⚠️ 주의사항

1. **무료 티어 제한**
   - Render 무료 티어는 15분 미사용 시 스핀다운됨
   - 첫 요청 시 약 30초 지연 가능
   - 월 750시간 제한

2. **MongoDB Atlas 제한**
   - 무료 티어: 512MB 저장공간
   - 동시 연결 제한

3. **CORS 설정**
   - 백엔드의 `main.py`에서 프론트엔드 도메인을 허용하도록 설정됨

## 🐛 문제 해결

### 백엔드가 시작되지 않는 경우
1. Render 로그 확인: Dashboard → godsaeng-backend → Logs
2. 환경 변수 확인
3. MongoDB 연결 문자열 확인

### 프론트엔드가 API에 연결되지 않는 경우
1. `VITE_API_BASE_URL` 환경 변수 확인
2. 백엔드 URL이 올바른지 확인
3. CORS 설정 확인

## 📚 추가 리소스

- Render 문서: https://render.com/docs
- MongoDB Atlas 문서: https://docs.atlas.mongodb.com

