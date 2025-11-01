# ✅ Render 배포 설정 완료 가이드

## 📋 현재 상태

✅ **완료된 작업**:
1. GitHub 저장소 연결: `smlee7179/godsaeng-project`
2. MongoDB Atlas 연결 완료
3. Render 설정 파일 준비 완료
4. 모든 변경사항 GitHub에 푸시 완료

## 🚀 Render 배포 단계

### Step 1: Render 대시보드 접속

https://dashboard.render.com 접속하고 GitHub로 로그인

### Step 2: 백엔드 서비스 생성

#### 방법 A: render.yaml 사용 (Blueprints) - 추천

1. Render 대시보드에서 **"New +"** → **"Blueprint"** 선택
2. GitHub 저장소 연결: `smlee7179/godsaeng-project`
3. `render.yaml` 파일 자동 인식
4. **환경 변수 설정** (중요!):
   - `MONGODB_URL`: 아래 값 사용
   ```
   mongodb+srv://smlee2257_db_user:MJBdSMaeBvSKgcZy@cluster0.zlcflwi.mongodb.net/godsaeng?retryWrites=true&w=majority
   ```
   - `FRONTEND_URL`: 프론트엔드 배포 후 URL로 업데이트 (임시: `https://godsaeng-frontend.onrender.com`)
5. **"Apply"** 클릭하여 배포 시작

#### 방법 B: 수동 생성

1. Render 대시보드에서 **"New +"** → **"Web Service"** 선택
2. GitHub 저장소 연결: `smlee7179/godsaeng-project`
3. 다음 설정 입력:
   ```
   Name: godsaeng-backend
   Root Directory: backend
   Environment: Python 3
   Build Command: pip install -r requirements.txt
   Start Command: uvicorn main:app --host 0.0.0.0 --port $PORT
   ```
4. **Environment Variables** 추가:
   ```
   MONGODB_URL=mongodb+srv://smlee2257_db_user:MJBdSMaeBvSKgcZy@cluster0.zlcflwi.mongodb.net/godsaeng?retryWrites=true&w=majority
   DATABASE_NAME=godsaeng
   JWT_SECRET_KEY=(랜덤 문자열 32자 이상)
   ACCESS_TOKEN_EXPIRE_MINUTES=30
   AI_PROVIDER=huggingface
   FRONTEND_URL=https://godsaeng-frontend.onrender.com
   ```
5. **"Create Web Service"** 클릭

### Step 3: 프론트엔드 서비스 생성

1. Render 대시보드에서 **"New +"** → **"Static Site"** 선택
2. GitHub 저장소 연결: `smlee7179/godsaeng-project`
3. 다음 설정 입력:
   ```
   Name: godsaeng-frontend
   Root Directory: frontend
   Build Command: npm install && npm run build
   Publish Directory: dist
   ```
4. **Environment Variables** 추가:
   ```
   VITE_API_BASE_URL=https://godsaeng-backend.onrender.com
   ```
   (백엔드 서비스의 실제 URL로 교체)
5. **"Create Static Site"** 클릭

### Step 4: 백엔드 FRONTEND_URL 업데이트

1. 프론트엔드 배포 완료 후 URL 복사 (예: `https://godsaeng-frontend.onrender.com`)
2. 백엔드 서비스 → **Environment** → `FRONTEND_URL` 업데이트
3. **"Save Changes"** 클릭하여 재배포

## 📝 환경 변수 요약

### 백엔드 (godsaeng-backend)
```
MONGODB_URL=mongodb+srv://smlee2257_db_user:MJBdSMaeBvSKgcZy@cluster0.zlcflwi.mongodb.net/godsaeng?retryWrites=true&w=majority
DATABASE_NAME=godsaeng
JWT_SECRET_KEY=(랜덤 문자열 32자 이상)
ACCESS_TOKEN_EXPIRE_MINUTES=30
AI_PROVIDER=huggingface
FRONTEND_URL=https://godsaeng-frontend.onrender.com (프론트엔드 배포 후 업데이트)
```

### 프론트엔드 (godsaeng-frontend)
```
VITE_API_BASE_URL=https://godsaeng-backend.onrender.com (백엔드 실제 URL)
```

## ✅ 배포 확인

1. **백엔드 확인**:
   - URL: `https://godsaeng-backend.onrender.com`
   - Health check: `https://godsaeng-backend.onrender.com/`
   - API docs: `https://godsaeng-backend.onrender.com/docs`

2. **프론트엔드 확인**:
   - URL: `https://godsaeng-frontend.onrender.com`
   - 브라우저에서 접속하여 테스트

## 🔧 문제 해결

### 배포 실패 시
1. **Logs** 탭에서 오류 확인
2. **Environment Variables** 확인
3. **Build Command** 및 **Start Command** 확인

### MongoDB 연결 실패
- `MONGODB_URL` 환경 변수 확인
- MongoDB Atlas Network Access 확인 (0.0.0.0/0)

### CORS 오류
- 백엔드 `FRONTEND_URL` 환경 변수 확인
- 프론트엔드 `VITE_API_BASE_URL` 확인

---

**배포 가이드 완료! Render 대시보드에서 배포를 진행하세요!** 🚀

