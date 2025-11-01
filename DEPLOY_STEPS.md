# 📝 배포 단계별 가이드

## ✅ 완료된 단계

1. ✅ Git 저장소 초기화
2. ✅ 모든 파일 커밋 완료
3. ✅ 배포 설정 파일 준비
4. ✅ 배포 가이드 문서 작성

## 🔄 진행해야 할 단계

### Step 1: GitHub 저장소 생성 (필수)

1. **GitHub 접속**: https://github.com/new
2. **저장소 생성**:
   - Repository name: `godsaeng-project` (또는 원하는 이름)
   - Description: "AI 기반 라이프 트래킹 웹 앱"
   - Public 또는 Private 선택
   - **중요**: README, .gitignore, license 추가하지 마세요!
3. **"Create repository"** 클릭
4. **명령어 복사 후 실행**:
   ```bash
   cd /Users/seungmin/Desktop/GODSAENG_PROJECT
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
   git push -u origin main
   ```

### Step 2: MongoDB Atlas 설정 (필수)

1. **계정 생성**: https://www.mongodb.com/cloud/atlas/register
2. **무료 클러스터 생성**: 
   - "Create a Deployment" → **FREE (M0)** 선택
   - 클라우드: AWS, 리전: 가장 가까운 지역
   - "Create Cluster" 클릭 (5분 소요)
3. **사용자 생성**:
   - Database Access → Add New Database User
   - Username/Password 설정 → 저장해두세요!
4. **네트워크 허용**:
   - Network Access → Add IP Address → "Allow Access from Anywhere" (0.0.0.0/0)
5. **연결 문자열 복사**:
   - Database → Connect → Connect your application
   - 연결 문자열 복사 후 데이터베이스 이름 추가:
     `mongodb+srv://user:pass@cluster0.xxxxx.mongodb.net/godsaeng?retryWrites=true&w=majority`

### Step 3: Render 백엔드 배포 (필수)

1. **Render 접속**: https://dashboard.render.com (GitHub 로그인)
2. **Web Service 생성**:
   - "New +" → "Web Service"
   - GitHub 저장소 연결
   - **설정**:
     ```
     Name: godsaeng-backend
     Root Directory: backend
     Environment: Python 3
     Build Command: pip install -r requirements.txt
     Start Command: uvicorn main:app --host 0.0.0.0 --port $PORT
     ```
3. **환경 변수**:
   ```
   MONGODB_URL=위에서_복사한_연결_문자열
   DATABASE_NAME=godsaeng
   JWT_SECRET_KEY=임의의_긴_문자열_32자_이상
   ACCESS_TOKEN_EXPIRE_MINUTES=30
   AI_PROVIDER=huggingface
   ```
4. **"Create Web Service"** 클릭
5. **배포 완료 대기** (5-10분)
6. **백엔드 URL 복사**: 예) `https://godsaeng-backend.onrender.com`

### Step 4: Render 프론트엔드 배포 (필수)

1. **Static Site 생성**:
   - Render 대시보드 → "New +" → "Static Site"
   - 같은 GitHub 저장소 선택
   - **설정**:
     ```
     Name: godsaeng-frontend
     Root Directory: frontend
     Build Command: npm install && npm run build
     Publish Directory: dist
     ```
2. **환경 변수**:
   ```
   VITE_API_BASE_URL=위에서_복사한_백엔드_URL
   ```
3. **"Create Static Site"** 클릭
4. **배포 완료 대기** (5-10분)

## 🎉 배포 완료 후

- ✅ 프론트엔드: `https://godsaeng-frontend.onrender.com`
- ✅ 백엔드: `https://godsaeng-backend.onrender.com`
- ✅ API 문서: `https://godsaeng-backend.onrender.com/docs`

## 🔍 테스트

1. 프론트엔드 URL 접속
2. 회원가입
3. 로그인
4. 기록 작성
5. AI 분석 확인

---

**각 단계를 순서대로 진행하세요!** 🚀

