# ✅ GODSAENG 완전 배포 가이드

## 🎯 배포 준비 완료!

모든 배포 파일과 설정이 준비되었습니다. 이제 실제 배포를 진행하세요!

## 📋 배포 단계 (20분 소요)

### Step 1: GitHub 저장소 생성 및 푸시 (5분)

#### 방법 1: 웹 브라우저 사용

1. **GitHub 접속**: https://github.com/new
2. **저장소 설정**:
   - Repository name: `godsaeng-project`
   - Description: "AI 기반 라이프 트래킹 웹 애플리케이션"
   - Public 또는 Private 선택
   - **중요**: README, .gitignore, license 추가하지 마세요!
3. **"Create repository"** 클릭
4. **터미널에서 실행**:
   ```bash
   cd /Users/seungmin/Desktop/GODSAENG_PROJECT
   git remote add origin https://github.com/YOUR_USERNAME/godsaeng-project.git
   git push -u origin main
   ```

#### 방법 2: GitHub CLI 사용 (자동)

```bash
cd /Users/seungmin/Desktop/GODSAENG_PROJECT
gh auth login
gh repo create godsaeng-project --public --source=. --remote=origin --push
```

### Step 2: MongoDB Atlas 설정 (5분)

1. **계정 생성**: https://www.mongodb.com/cloud/atlas/register
2. **무료 클러스터 생성**:
   - "Create a Deployment" → **FREE (M0)** 선택
   - 클라우드 제공자: AWS
   - 리전: 가장 가까운 지역 (예: N. Virginia)
   - "Create Cluster" 클릭 (약 5분 소요)

3. **데이터베이스 사용자 생성**:
   - "Database Access" → "Add New Database User"
   - Username: `godsaeng_user` smlee2257_db_user
   - Password: 강력한 비밀번호 생성 (저장!) MJBdSMaeBvSKgcZy
   - Privileges: "Atlas admin"
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
   - 이 문자열을 복사해두세요!

### Step 3: Render 백엔드 배포 (5분)

1. **Render 접속**: https://dashboard.render.com (GitHub로 로그인)

2. **Web Service 생성**:
   - "New +" → "Web Service" 클릭
   - "Connect GitHub" → 저장소 선택 (`godsaeng-project`)
   
3. **서비스 설정**:
   ```
   Name: godsaeng-backend
   Root Directory: backend
   Environment: Python 3
   Build Command: pip install -r requirements.txt
   Start Command: uvicorn main:app --host 0.0.0.0 --port $PORT
   ```
   (Plan은 "Free" 선택)

4. **환경 변수 설정** (Advanced → Environment):
   ```
   MONGODB_URL=mongodb+srv://godsaeng_user:PASSWORD@cluster0.xxxxx.mongodb.net/godsaeng?retryWrites=true&w=majority
   DATABASE_NAME=godsaeng
   JWT_SECRET_KEY=your-super-secret-jwt-key-change-in-production-min-32-characters-long
   ACCESS_TOKEN_EXPIRE_MINUTES=30
   AI_PROVIDER=huggingface
   ```
   (MONGODB_URL은 Step 2에서 복사한 문자열로 교체)

5. **"Create Web Service"** 클릭

6. **배포 대기**:
   - 배포 완료까지 약 5-10분 소요
   - Logs 탭에서 진행 상황 확인
   - 배포 완료 후 URL 복사: 예) `https://godsaeng-backend.onrender.com`

### Step 4: Render 프론트엔드 배포 (5분)

1. **Static Site 생성**:
   - Render 대시보드 → "New +" → "Static Site"
   - "Connect GitHub" → 같은 저장소 선택 (`godsaeng-project`)

2. **서비스 설정**:
   ```
   Name: godsaeng-frontend
   Root Directory: frontend
   Build Command: npm install && npm run build
   Publish Directory: dist
   ```

3. **환경 변수 설정**:
   ```
   VITE_API_BASE_URL=https://godsaeng-backend.onrender.com
   ```
   (Step 3에서 복사한 백엔드 URL 사용)

4. **"Create Static Site"** 클릭

5. **배포 대기**:
   - 배포 완료까지 약 5-10분 소요

## 🎉 배포 완료!

배포 완료 후 접속 가능한 URL:
- ✅ **프론트엔드**: `https://godsaeng-frontend.onrender.com`
- ✅ **백엔드 API**: `https://godsaeng-backend.onrender.com`
- ✅ **API 문서**: `https://godsaeng-backend.onrender.com/docs`

## 🧪 테스트

1. **프론트엔드 접속**: 브라우저에서 프론트엔드 URL 열기
2. **회원가입**: 새 계정 생성
3. **로그인**: 생성한 계정으로 로그인
4. **기록 작성**: 일상 기록 작성
5. **AI 분석**: AI 리포트 생성 및 확인

## 🔍 배포 확인

### 백엔드 확인
```bash
curl https://godsaeng-backend.onrender.com/
curl https://godsaeng-backend.onrender.com/config
```

### 프론트엔드 확인
- 브라우저에서 프론트엔드 URL 접속
- 회원가입/로그인 테스트

## ⚠️ 주의사항

1. **무료 티어 제한**:
   - Render: 15분 미사용 시 자동 스핀다운, 첫 요청 시 약 30초 지연
   - MongoDB Atlas: 512MB 저장공간 제한

2. **환경 변수 보안**:
   - `JWT_SECRET_KEY`는 강력한 비밀번호 사용
   - MongoDB 비밀번호는 안전하게 보관

3. **자동 재배포**:
   - GitHub에 `git push`하면 Render가 자동으로 재배포합니다

## 🆘 문제 해결

### 백엔드 배포 실패
1. Render 대시보드 → 서비스 → Logs 확인
2. MongoDB 연결 문자열 확인
3. 환경 변수 확인

### 프론트엔드 API 연결 실패
1. `VITE_API_BASE_URL` 환경 변수 확인
2. 백엔드 URL이 올바른지 확인
3. CORS 설정 확인 (이미 설정됨)

### MongoDB 연결 실패
1. MongoDB Atlas 네트워크 접근 확인 (0.0.0.0/0)
2. 사용자 이름/비밀번호 확인
3. 연결 문자열 형식 확인

## 📝 배포 정보 저장

배포 완료 후 아래 정보를 기록하세요:

```bash
# 배포 정보
백엔드 URL: https://___________________.onrender.com
프론트엔드 URL: https://___________________.onrender.com
MongoDB Atlas: cluster0.xxxxx.mongodb.net
배포 날짜: ____년 __월 __일
```

---

**모든 준비 완료! 지금 바로 배포하세요!** 🚀

