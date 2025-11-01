# ⚡ 빠른 배포 가이드 (5분 안에)

## 🚀 단계별 배포

### 1️⃣ GitHub 저장소 준비 (2분)

```bash
cd /Users/seungmin/Desktop/GODSAENG_PROJECT

# Git 초기화 (이미 되어있으면 생략)
git init
git add .
git commit -m "Initial commit"
git branch -M main

# GitHub에서 새 저장소 생성 후:
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main
```

### 2️⃣ MongoDB Atlas 설정 (2분)

1. **계정 생성**: https://www.mongodb.com/cloud/atlas/register
2. **무료 클러스터 생성**:
   - "Create a Deployment" → FREE 선택 → Create
3. **데이터베이스 사용자 생성**:
   - Database Access → Add New Database User
   - Username/Password 설정 → Add User
4. **네트워크 접근 허용**:
   - Network Access → Add IP Address → "Allow Access from Anywhere" (0.0.0.0/0)
5. **연결 문자열 복사**:
   - Database → Connect → Connect your application
   - 연결 문자열 복사 (예: `mongodb+srv://user:pass@cluster0.xxxxx.mongodb.net/godsaeng?retryWrites=true&w=majority`)

### 3️⃣ Render 배포 (3분)

#### 백엔드 배포
1. https://dashboard.render.com 접속
2. "New +" → "Web Service" 클릭
3. GitHub 저장소 연결
4. 설정 입력:
   - **Name**: `godsaeng-backend`
   - **Root Directory**: `backend`
   - **Environment**: `Python 3`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `uvicorn main:app --host 0.0.0.0 --port $PORT`
5. 환경 변수 추가:
   ```
   MONGODB_URL=mongodb+srv://user:pass@cluster0.xxxxx.mongodb.net/godsaeng?retryWrites=true&w=majority
   DATABASE_NAME=godsaeng
   JWT_SECRET_KEY=your-secret-key-here
   ACCESS_TOKEN_EXPIRE_MINUTES=30
   AI_PROVIDER=huggingface
   ```
6. "Create Web Service" 클릭
7. 백엔드 URL 복사 (예: `https://godsaeng-backend.onrender.com`)

#### 프론트엔드 배포
1. Render 대시보드에서 "New +" → "Static Site" 클릭
2. 같은 GitHub 저장소 연결
3. 설정 입력:
   - **Name**: `godsaeng-frontend`
   - **Root Directory**: `frontend`
   - **Build Command**: `npm install && npm run build`
   - **Publish Directory**: `dist`
4. 환경 변수 추가:
   ```
   VITE_API_BASE_URL=https://godsaeng-backend.onrender.com
   ```
5. "Create Static Site" 클릭

### 4️⃣ 완료! 🎉

배포 완료 후 (5-10분):
- ✅ 프론트엔드: `https://godsaeng-frontend.onrender.com`
- ✅ 백엔드 API: `https://godsaeng-backend.onrender.com`
- ✅ API 문서: `https://godsaeng-backend.onrender.com/docs`

## 🔧 자동 배포 스크립트 사용

```bash
./deploy-to-render.sh
```

## ❓ 문제 해결

### 백엔드가 시작되지 않음
- Render 로그 확인 (Dashboard → 서비스 → Logs)
- MongoDB 연결 문자열 확인
- 환경 변수 확인

### 프론트엔드가 백엔드에 연결 안됨
- `VITE_API_BASE_URL` 환경 변수 확인
- 백엔드 URL이 올바른지 확인

## 📚 상세 가이드

더 자세한 내용은 `DEPLOY_RENDER.md`를 참고하세요.

