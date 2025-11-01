# 🗄️ MongoDB Atlas 연결 가이드

## ✅ 준비된 정보

- **Username**: `smlee2257_db_user`
- **Password**: `MJBdSMaeBvSKgcZy`
- **Database**: `godsaeng`

## 🔗 MongoDB Atlas 연결하기

### 방법 1: 자동 연결 스크립트 (추천)

```bash
cd /Users/seungmin/Desktop/GODSAENG_PROJECT
./test-mongodb-connection.py
```

또는

```bash
./connect-mongodb-atlas.sh
```

스크립트가 클러스터 호스트를 물어보면, MongoDB Atlas에서 확인한 값을 입력하세요.

### 방법 2: 수동 연결

1. **MongoDB Atlas 클러스터 호스트 확인**:
   - https://cloud.mongodb.com 접속
   - Database → Connect → "Connect your application"
   - 연결 문자열에서 `cluster0.xxxxx.mongodb.net` 부분 복사

2. **연결 문자열 생성**:
   ```
   mongodb+srv://smlee2257_db_user:MJBdSMaeBvSKgcZy@cluster0.xxxxx.mongodb.net/godsaeng?retryWrites=true&w=majority
   ```
   (cluster0.xxxxx.mongodb.net 부분을 실제 클러스터 호스트로 교체)

3. **연결 테스트**:
   ```bash
   cd /Users/seungmin/Desktop/GODSAENG_PROJECT/backend
   source venv/bin/activate
   python3 test-mongodb-connection.py
   ```

## 📋 MongoDB Atlas 설정 체크리스트

### 1. 클러스터 생성 확인
- [ ] MongoDB Atlas 대시보드 접속: https://cloud.mongodb.com
- [ ] 클러스터가 생성되었는지 확인
- [ ] 클러스터 생성 중이면 완료될 때까지 대기 (5분)

### 2. 데이터베이스 사용자 확인
- [ ] Database Access → 사용자 목록 확인
- [ ] `smlee2257_db_user` 사용자가 있는지 확인
- [ ] 비밀번호가 올바른지 확인

### 3. 네트워크 접근 확인
- [ ] Network Access → IP 목록 확인
- [ ] `0.0.0.0/0` (Allow Access from Anywhere)이 있는지 확인
- [ ] 없으면 "Add IP Address" → "Allow Access from Anywhere" 추가

### 4. 연결 문자열 확인
- [ ] Database → Connect → "Connect your application"
- [ ] 연결 문자열에서 클러스터 호스트 확인
- [ ] 예: `cluster0.xxxxx.mongodb.net`

## 🔧 연결 문자열 사용

### 로컬 테스트

```bash
cd /Users/seungmin/Desktop/GODSAENG_PROJECT/backend
source venv/bin/activate

# 환경 변수 설정
export MONGODB_URL="mongodb+srv://smlee2257_db_user:MJBdSMaeBvSKgcZy@cluster0.xxxxx.mongodb.net/godsaeng?retryWrites=true&w=majority"
export DATABASE_NAME="godsaeng"

# 백엔드 실행
uvicorn main:app --reload
```

### Render 배포

Render 대시보드에서 환경 변수 설정:
```
MONGODB_URL=mongodb+srv://smlee2257_db_user:MJBdSMaeBvSKgcZy@cluster0.xxxxx.mongodb.net/godsaeng?retryWrites=true&w=majority
DATABASE_NAME=godsaeng
```

## 🧪 연결 테스트

연결 테스트 스크립트 실행:

```bash
cd /Users/seungmin/Desktop/GODSAENG_PROJECT
python3 test-mongodb-connection.py
```

또는

```bash
./connect-mongodb-atlas.sh
```

## ⚠️ 문제 해결

### 연결 실패 시

1. **클러스터 상태 확인**:
   - 클러스터가 생성 완료되었는지 확인
   - 클러스터 이름 확인

2. **네트워크 접근 확인**:
   - Network Access에 `0.0.0.0/0`이 있는지 확인
   - 없으면 추가 (5분 소요 가능)

3. **사용자 확인**:
   - Database Access에서 사용자 존재 확인
   - 비밀번호가 올바른지 확인

4. **클러스터 호스트 확인**:
   - 연결 문자열에서 정확한 호스트명 확인

## 📝 다음 단계

연결 성공 후:
1. `.env.atlas` 파일 확인 (연결 문자열 저장됨)
2. Render 배포 시 이 연결 문자열 사용
3. 로컬 테스트 진행

---

**연결 테스트를 실행하세요!** 🚀

