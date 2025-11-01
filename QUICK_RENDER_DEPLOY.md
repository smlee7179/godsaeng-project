# ⚡ Render 빠른 배포 가이드

## ✅ 준비 완료된 항목

1. ✅ GitHub 저장소: `smlee7179/godsaeng-project`
2. ✅ MongoDB Atlas 연결 완료
3. ✅ 모든 코드 푸시 완료
4. ✅ Render 설정 파일 준비 완료

## 🚀 Render 대시보드에서 배포하기 (5분)

### 방법 1: Blueprint 사용 (가장 빠름) ⭐ 추천

1. **Render 대시보드 접속**:
   https://dashboard.render.com/new/blueprint-spec

2. **GitHub 저장소 연결**:
   - "Public Git repository" 선택
   - `smlee7179/godsaeng-project` 입력
   - "Apply" 클릭

3. **환경 변수 설정**:
   Blueprint가 자동으로 감지되지만, 다음 환경 변수를 확인:
   ```
   MONGODB_URL=mongodb+srv://smlee2257_db_user:MJBdSMaeBvSKgcZy@cluster0.zlcflwi.mongodb.net/godsaeng?retryWrites=true&w=majority
   ```
   (MONGODB_URL은 수동으로 추가 필요)

4. **"Apply"** 클릭하여 배포 시작

### 방법 2: 수동 서비스 생성

#### 백엔드 서비스 (Web Service)

1. **Render 대시보드**: https://dashboard.render.com/new/web-service

2. **GitHub 저장소 연결**: `smlee7179/godsaeng-project`

3. **설정 입력**:
   ```
   Name: godsaeng-backend
   Root Directory: backend
   Environment: Python 3
   Build Command: pip install -r requirements.txt
   Start Command: uvicorn main:app --host 0.0.0.0 --port $PORT
   ```

4. **환경 변수 추가**:
   ```
   MONGODB_URL=mongodb+srv://smlee2257_db_user:MJBdSMaeBvSKgcZy@cluster0.zlcflwi.mongodb.net/godsaeng?retryWrites=true&w=majority
   DATABASE_NAME=godsaeng
   JWT_SECRET_KEY=(랜덤 32자 이상)
   ACCESS_TOKEN_EXPIRE_MINUTES=30
   AI_PROVIDER=huggingface
   FRONTEND_URL=https://godsaeng-frontend.onrender.com
   ```

5. **"Create Web Service"** 클릭

#### 프론트엔드 서비스 (Static Site)

1. **Render 대시보드**: https://dashboard.render.com/new/static-site

2. **GitHub 저장소 연결**: `smlee7179/godsaeng-project`

3. **설정 입력**:
   ```
   Name: godsaeng-frontend
   Root Directory: frontend
   Build Command: npm install && npm run build
   Publish Directory: dist
   ```

4. **환경 변수 추가**:
   ```
   VITE_API_BASE_URL=https://godsaeng-backend.onrender.com
   ```
   (백엔드 배포 후 실제 URL로 교체)

5. **"Create Static Site"** 클릭

## 📋 필수 환경 변수 요약

### 백엔드
```
MONGODB_URL=mongodb+srv://smlee2257_db_user:MJBdSMaeBvSKgcZy@cluster0.zlcflwi.mongodb.net/godsaeng?retryWrites=true&w=majority
DATABASE_NAME=godsaeng
FRONTEND_URL=https://godsaeng-frontend.onrender.com
```

### 프론트엔드
```
VITE_API_BASE_URL=https://godsaeng-backend.onrender.com
```

## ✅ 배포 확인

1. **백엔드 확인**: `https://godsaeng-backend.onrender.com`
2. **프론트엔드 확인**: `https://godsaeng-frontend.onrender.com`

---

**지금 바로 Render 대시보드에서 배포하세요!** 🚀

