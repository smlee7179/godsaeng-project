# 📊 Render 대시보드 로그 확인 가이드

## 🔍 로그 확인 방법

### 1. Render 대시보드 접속
https://dashboard.render.com

### 2. 백엔드 로그 확인

**경로**: Dashboard → godsaeng-backend → Logs 탭

**확인할 항목**:

#### 빌드 로그 (Build Logs)
```
✅ 정상: "Successfully installed ..."
✅ 정상: "Collecting fastapi..."
✅ 정상: "Building wheels..."
❌ 오류: "ERROR: Could not find a version..."
❌ 오류: "ERROR: Command errored out..."
```

#### 실행 로그 (Runtime Logs)
```
✅ 정상: "INFO:     Started server process"
✅ 정상: "INFO:     Uvicorn running on http://0.0.0.0:PORT"
✅ 정상: "✅ MongoDB 연결 성공: godsaeng"
❌ 오류: "❌ MongoDB 연결 실패: ..."
❌ 오류: "ValueError: MONGODB_URL 환경 변수가 설정되지 않았습니다."
❌ 오류: "ModuleNotFoundError: No module named '...'"
❌ 오류: "ImportError: ..."
❌ 오류: "SyntaxError: ..."
```

### 3. 프론트엔드 로그 확인

**경로**: Dashboard → godsaeng-frontend → Logs 탭

**확인할 항목**:

#### 빌드 로그 (Build Logs)
```
✅ 정상: "added XXX packages"
✅ 정상: "vite v5.x.x building for production..."
✅ 정상: "✓ built in X.XXs"
✅ 정상: "dist/index.html"
❌ 오류: "npm ERR! code ..."
❌ 오류: "npm ERR! ..."
❌ 오류: "Error: ..."
```

## 🐛 일반적인 오류 및 해결 방법

### 백엔드 오류

#### 1. MongoDB 연결 실패
```
❌ MongoDB 연결 실패: ...
```
**해결**:
- Render 대시보드 → godsaeng-backend → Environment 탭
- `MONGODB_URL` 환경 변수 확인
- MongoDB Atlas 연결 문자열 확인

#### 2. 의존성 설치 실패
```
ERROR: Could not find a version...
```
**해결**:
- requirements.txt 버전 확인
- Python 버전 호환성 확인 (runtime.txt)

#### 3. 모듈 임포트 오류
```
ModuleNotFoundError: No module named '...'
```
**해결**:
- requirements.txt에 패키지 추가
- 재배포 실행

### 프론트엔드 오류

#### 1. npm install 실패
```
npm ERR! code ...
```
**해결**:
- package.json 확인
- node_modules 삭제 후 재배포

#### 2. 빌드 실패
```
Error: ... during build
```
**해결**:
- 빌드 로그 전체 확인
- package.json 스크립트 확인

## 📋 체크리스트

### 백엔드 체크리스트
- [ ] 빌드 로그에서 "Successfully installed" 확인
- [ ] 실행 로그에서 "INFO: Started server process" 확인
- [ ] 실행 로그에서 "✅ MongoDB 연결 성공" 확인
- [ ] 환경 변수 `MONGODB_URL` 설정 확인
- [ ] 환경 변수 `FRONTEND_URL` 설정 확인

### 프론트엔드 체크리스트
- [ ] 빌드 로그에서 "✓ built in" 확인
- [ ] dist 폴더 생성 확인
- [ ] 환경 변수 `VITE_API_BASE_URL` 설정 확인

## 🔧 로그 분석 결과

현재 상태는 `render_log_analysis.json`에 저장되어 있습니다.

