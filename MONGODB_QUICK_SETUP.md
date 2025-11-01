# ⚡ MongoDB Atlas 빠른 연결 가이드

## ✅ 준비된 정보

- **Username**: `smlee2257_db_user`
- **Password**: `MJBdSMaeBvSKgcZy`
- **Database**: `godsaeng`

## 🚀 빠른 연결 (3단계)

### Step 1: MongoDB Atlas 확인 (1분)

1. **대시보드 접속**: https://cloud.mongodb.com
2. **클러스터 확인**:
   - 왼쪽 메뉴 "Database" 클릭
   - 클러스터가 보이는지 확인
   - 없으면 "Create a Deployment" → FREE 선택 → Create

3. **네트워크 접근 확인**:
   - "Network Access" 메뉴 클릭
   - IP 주소에 `0.0.0.0/0`이 있는지 확인
   - 없으면 "Add IP Address" → "Allow Access from Anywhere" 추가

### Step 2: 클러스터 호스트 확인 (1분)

1. **연결 문자열 가져오기**:
   - Database → 클러스터 → "Connect" 버튼
   - "Connect your application" 선택
   - 연결 문자열에서 클러스터 호스트 찾기
   - 예: `cluster0.xxxxx.mongodb.net`

2. **클러스터 호스트 복사**: `cluster0.xxxxx.mongodb.net` 부분만

### Step 3: 연결 테스트 (1분)

터미널에서 실행:

```bash
cd /Users/seungmin/Desktop/GODSAENG_PROJECT
./setup-mongodb-atlas.sh
```

또는:

```bash
python3 test-mongodb-connection.py
```

클러스터 호스트를 입력하세요.

## ✅ 연결 성공 시

연결 성공하면:
- `.env.atlas` 파일에 연결 문자열 저장됨
- 이 연결 문자열을 Render 배포 시 사용

## ❌ 연결 실패 시

1. **클러스터 상태 확인**: 생성 완료되었는지 확인
2. **네트워크 접근 확인**: 0.0.0.0/0이 있는지 확인
3. **클러스터 호스트 확인**: 정확한 호스트명 확인

## 📝 Render 배포 시 사용

연결 문자열이 `.env.atlas` 파일에 저장되면:
- Render 대시보드 → 환경 변수에 추가
- `MONGODB_URL` 변수에 저장된 값 사용

---

**지금 연결 테스트를 실행하세요!** 🚀

