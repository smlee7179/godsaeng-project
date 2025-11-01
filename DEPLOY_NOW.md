# 🚀 지금 바로 배포하기!

## ⚡ 빠른 배포 (5분)

### Step 1: GitHub 저장소 생성 및 푸시 (2분)

1. **GitHub 저장소 생성**
   - https://github.com/new 접속
   - 저장소 이름: `godsaeng-project` (또는 원하는 이름)
   - Public 또는 Private 선택
   - **중요**: README, .gitignore, license는 추가하지 마세요!

2. **GitHub에 푸시**
   ```bash
   cd /Users/seungmin/Desktop/GODSAENG_PROJECT
   
   # 원격 저장소 추가 (YOUR_USERNAME과 YOUR_REPO_NAME 변경)
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
   
   # 푸시
   git push -u origin main
   ```

### Step 2: MongoDB Atlas 설정 (2분)

1. **계정 생성**: https://www.mongodb.com/cloud/atlas/register
2. **무료 클러스터 생성**:
   - "Create a Deployment" → **FREE (M0)** 선택
   - 클라우드: AWS
   - 리전: 가장 가까운 지역 (예: N. Virginia)
   - "Create Cluster" 클릭 (약 5분 소요)

3. **데이터베이스 사용자 생성**:
   - "Database Access" → "Add New Database User"
   - Username: `godsaeng_user` (원하는 이름)
   - Password: 강력한 비밀번호 생성 (저장해두세요!)
   - User Privileges: "Atlas admin"
   - "Add User" 클릭

4. **네트워크 접근 허용**:
   - "Network Access" → "Add IP Address"
   - **"Allow Access from Anywhere"** 선택 (0.0.0.0/0)
   - "Confirm" 클릭

5. **연결 문자열 복사**:
   - "Database" → "Connect" → "Connect your application"
   - Driver: Python, Version: 3.6 or later
   - 연결 문자열 복사
   - **데이터베이스 이름 추가**: 
     ```
     mongodb+srv://godsaeng_user:PASSWORD@cluster0.xxxxx.mongodb.net/godsaeng?retryWrites=true&w=majority
     ```
   - 이 연결 문자열을 복사해두세요!

### Step 3: Render 백엔드 배포 (1분)

1. **Render 접속**: https://dashboard.render.com (GitHub로 로그인)

2. **백엔드 서비스 생성**:
   - "New +" → "Web Service" 클릭
   - "Connect GitHub" → 저장소 선택
   - **설정 입력**:
     ```
     Name: godsaeng-backend
     Root Directory: backend
     Environment: Python 3
     Build Command: pip install -r requirements.txt
     Start Command: uvicorn main:app --host 0.0.0.0 --port $PORT
     ```
   
3. **환경 변수 설정** (Advanced → Environment):
   ```
   MONGODB_URL=mongodb+srv://godsaeng_user:PASSWORD@cluster0.xxxxx.mongodb.net/godsaeng?retryWrites=true&w=majority
   DATABASE_NAME=godsaeng
   JWT_SECRET_KEY=your-super-secret-jwt-key-change-in-production-min-32-chars
   ACCESS_TOKEN_EXPIRE_MINUTES=30
   AI_PROVIDER=huggingface
   ```
   (MONGODB_URL은 위에서 복사한 문자열로 교체)

4. **"Create Web Service"** 클릭

5. **백엔드 URL 대기**: 배포 완료 후 URL 복사
   - 예: `https://godsaeng-backend.onrender.com`
   - 배포는 5-10분 소요됩니다

### Step 4: Render 프론트엔드 배포 (1분)

1. **프론트엔드 서비스 생성**:
   - Render 대시보드 → "New +" → "Static Site"
   - 같은 GitHub 저장소 선택
   - **설정 입력**:
     ```
     Name: godsaeng-frontend
     Root Directory: frontend
     Build Command: npm install && npm run build
     Publish Directory: dist
     ```

2. **환경 변수 설정**:
   ```
   VITE_API_BASE_URL=https://godsaeng-backend.onrender.com
   ```
   (위에서 복사한 백엔드 URL 사용)

3. **"Create Static Site"** 클릭

4. **배포 완료 대기**: 5-10분 소요

## 🎉 배포 완료!

배포 완료 후:
- ✅ **프론트엔드**: `https://godsaeng-frontend.onrender.com`
- ✅ **백엔드 API**: `https://godsaeng-backend.onrender.com`
- ✅ **API 문서**: `https://godsaeng-backend.onrender.com/docs`

## 🔍 배포 확인

1. **프론트엔드 접속**: 브라우저에서 프론트엔드 URL 열기
2. **회원가입 테스트**: 새 계정 생성
3. **기능 테스트**: 기록 작성, AI 분석 등

## ⚠️ 참고사항

1. **무료 티어 제한**:
   - 15분 미사용 시 자동 스핀다운
   - 첫 요청 시 약 30초 지연 가능

2. **자동 재배포**:
   - GitHub에 `git push`하면 자동으로 재배포됩니다

3. **로그 확인**:
   - Render 대시보드 → 서비스 → Logs

## 🆘 문제 해결

### 백엔드 배포 실패
- Render 로그 확인
- MongoDB 연결 문자열 확인
- 환경 변수 확인

### 프론트엔드가 API에 연결 안됨
- `VITE_API_BASE_URL` 환경 변수 확인
- 백엔드 URL이 올바른지 확인

---

**준비 완료! 지금 바로 배포하세요!** 🚀

