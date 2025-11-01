# 🚀 GODSAENG Render 클라우드 배포 - 최종 가이드

## ✅ 배포 준비 완료!

모든 배포 파일이 준비되었습니다. 이제 5분 안에 배포할 수 있습니다.

## 📋 배포 단계

### 1단계: GitHub 저장소 설정 (1분)

```bash
cd /Users/seungmin/Desktop/GODSAENG_PROJECT

# Git 초기화 (필요시)
git init

# 모든 파일 추가
git add .

# 커밋
git commit -m "Initial commit"

# 브랜치 이름 변경
git branch -M main

# GitHub에서 새 저장소 생성 후:
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main
```

### 2단계: MongoDB Atlas 설정 (2분)

1. **회원가입**: https://www.mongodb.com/cloud/atlas/register
2. **무료 클러스터 생성**: 
   - "Create a Deployment" → **FREE (M0)** 선택
   - 클라우드: AWS
   - 리전: 가장 가까운 지역
   - "Create" 클릭 (약 5분 소요)
3. **사용자 생성**:
   - "Database Access" → "Add New Database User"
   - Username/Password 설정
   - "Atlas admin" 권한 선택
   - "Add User" 클릭
4. **네트워크 허용**:
   - "Network Access" → "Add IP Address"
   - **"Allow Access from Anywhere"** 선택 (0.0.0.0/0)
   - "Confirm" 클릭
5. **연결 문자열 복사**:
   - "Database" → "Connect" → "Connect your application"
   - 연결 문자열 복사
   - 데이터베이스 이름 추가: `...mongodb.net/godsaeng?retryWrites=true&w=majority`

### 3단계: Render 백엔드 배포 (2분)

1. **Render 접속**: https://dashboard.render.com (GitHub 로그인)
2. **새 서비스 생성**: "New +" → "Web Service"
3. **GitHub 저장소 연결**: 저장소 선택
4. **설정 입력**:
   ```
   Name: godsaeng-backend
   Root Directory: backend
   Environment: Python 3
   Build Command: pip install -r requirements.txt
   Start Command: uvicorn main:app --host 0.0.0.0 --port $PORT
   ```
5. **환경 변수 설정**:
   ```
   MONGODB_URL=mongodb+srv://user:pass@cluster0.xxxxx.mongodb.net/godsaeng?retryWrites=true&w=majority
   DATABASE_NAME=godsaeng
   JWT_SECRET_KEY=your-super-secret-key-here-min-32-chars
   ACCESS_TOKEN_EXPIRE_MINUTES=30
   AI_PROVIDER=huggingface
   ```
6. **"Create Web Service"** 클릭
7. **백엔드 URL 복사**: 예) `https://godsaeng-backend.onrender.com`

### 4단계: Render 프론트엔드 배포 (1분)

1. **Render 대시보드**: "New +" → "Static Site"
2. **같은 GitHub 저장소 연결**
3. **설정 입력**:
   ```
   Name: godsaeng-frontend
   Root Directory: frontend
   Build Command: npm install && npm run build
   Publish Directory: dist
   ```
4. **환경 변수 설정**:
   ```
   VITE_API_BASE_URL=https://godsaeng-backend.onrender.com
   ```
   (위에서 복사한 백엔드 URL 사용)
5. **"Create Static Site"** 클릭

## 🎉 배포 완료!

배포가 완료되면 (5-10분 소요):
- **프론트엔드**: `https://godsaeng-frontend.onrender.com`
- **백엔드 API**: `https://godsaeng-backend.onrender.com`
- **API 문서**: `https://godsaeng-backend.onrender.com/docs`

## 🔧 유용한 명령어

```bash
# 배포 상태 확인
./deploy-status.sh

# 자동 배포 스크립트
./deploy-to-render.sh

# 상세 가이드
cat DEPLOY_RENDER.md

# 빠른 가이드
cat QUICK_DEPLOY.md
```

## ⚠️ 중요 사항

1. **무료 티어 제한**:
   - 15분 미사용 시 자동 스핀다운
   - 첫 요청 시 30초 지연 가능
   - 월 750시간 제한

2. **자동 배포**:
   - GitHub에 푸시하면 자동 재배포
   - `git push` 후 Render 대시보드에서 확인

3. **환경 변수 수정**:
   - Render 대시보드 → 서비스 → Environment
   - 환경 변수 수정 후 자동 재시작

## 📚 추가 문서

- **QUICK_DEPLOY.md**: 빠른 배포 가이드
- **DEPLOY_RENDER.md**: 상세 배포 가이드
- **RENDER_SETUP.md**: 배포 체크리스트

## 🆘 문제 해결

### 백엔드 배포 실패
1. Render 로그 확인 (Dashboard → Logs)
2. MongoDB 연결 문자열 확인
3. 환경 변수 확인

### 프론트엔드 API 연결 실패
1. `VITE_API_BASE_URL` 환경 변수 확인
2. 백엔드 URL이 올바른지 확인
3. CORS 설정 확인

---

**준비 완료! 이제 배포할 수 있습니다!** 🚀

