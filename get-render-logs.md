# 📋 Render 로그 직접 확인 방법

## 🔍 로그 확인 경로

### 백엔드 로그
1. https://dashboard.render.com 접속
2. `godsaeng-backend` 서비스 클릭
3. 왼쪽 메뉴에서 **"Logs"** 탭 클릭

### 프론트엔드 로그
1. `godsaeng-frontend` 서비스 클릭
2. **"Logs"** 탭 클릭

## 📊 로그 종류

### 1. 빌드 로그 (Build Logs)
패키지 설치 과정을 보여줍니다.

**정상 패턴**:
```
Collecting fastapi==0.104.1
  Downloading fastapi-0.104.1-py3-none-any.whl
...
Successfully installed fastapi-0.104.1 ...
```

**오류 패턴**:
```
ERROR: Could not find a version that satisfies the requirement ...
ERROR: Command errored out with exit status 1
```

### 2. 실행 로그 (Runtime Logs)
애플리케이션 실행 과정을 보여줍니다.

**정상 패턴**:
```
INFO:     Started server process
INFO:     Uvicorn running on http://0.0.0.0:PORT
✅ MongoDB 연결 성공: godsaeng
```

**오류 패턴**:
```
❌ MongoDB 연결 실패: ...
ValueError: MONGODB_URL 환경 변수가 설정되지 않았습니다.
ModuleNotFoundError: No module named '...'
ImportError: cannot import name '...'
SyntaxError: ...
```

## 🐛 일반적인 오류 및 해결

### MongoDB 연결 실패
```
❌ MongoDB 연결 실패: ...
ValueError: MONGODB_URL 환경 변수가 설정되지 않았습니다.
```

**해결**:
1. Render 대시보드 → godsaeng-backend → Environment
2. `MONGODB_URL` 환경 변수 추가/수정
3. MongoDB Atlas 연결 문자열 확인

### 모듈 임포트 오류
```
ModuleNotFoundError: No module named '...'
ImportError: cannot import name '...'
```

**해결**:
1. requirements.txt에 누락된 패키지 추가
2. 재배포 실행

### 의존성 설치 실패
```
ERROR: Could not find a version...
ERROR: Command errored out...
```

**해결**:
1. requirements.txt 패키지 버전 확인
2. 호환되는 버전으로 수정

## 📝 로그 복사 방법

1. Render 로그 화면에서 스크롤하여 전체 로그 확인
2. 텍스트 선택 후 복사
3. 파일로 저장하여 공유 가능

---

**Render 대시보드에서 실제 로그를 확인하면 정확한 오류 원인을 파악할 수 있습니다.**

