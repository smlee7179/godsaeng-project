# 🔍 MongoDB Atlas 클러스터 정보 확인 방법

## ✅ 클러스터가 생성되었다면

MongoDB Atlas 대시보드에서 정확한 클러스터 호스트를 확인해야 합니다.

## 📋 클러스터 호스트 확인 방법

### Step 1: MongoDB Atlas 대시보드 접속
https://cloud.mongodb.com

### Step 2: 클러스터 정보 확인

1. **Database 메뉴 클릭** (왼쪽 사이드바)
2. **클러스터 선택** (생성된 클러스터 이름 클릭)
3. **"Connect" 버튼 클릭** (클러스터 카드 우측 상단)
4. **"Connect your application" 선택**
5. **연결 문자열 확인**:
   ```
   mongodb+srv://<username>:<password>@<cluster-host>/<database>?retryWrites=true&w=majority
   ```
   이 문자열에서 `<cluster-host>` 부분을 찾으세요.
   예: `cluster0.abc123def456.mongodb.net`

### Step 3: 클러스터 상태 확인

- 클러스터가 "Creating" 상태면 완료될 때까지 대기 (약 5분)
- "Idle" 상태여야 연결 가능

### Step 4: 네트워크 접근 확인

1. **Network Access 메뉴 클릭** (왼쪽 사이드바)
2. IP 주소 목록 확인
3. `0.0.0.0/0` (Allow Access from Anywhere)이 있어야 함
4. 없으면:
   - "Add IP Address" 클릭
   - "Allow Access from Anywhere" 선택
   - "Confirm" 클릭 (적용까지 몇 분 소요)

## 🚀 연결 테스트

클러스터 호스트를 확인했다면:

```bash
cd /Users/seungmin/Desktop/GODSAENG_PROJECT
./connect-now.sh
```

클러스터 호스트를 입력하세요.

## ❌ 문제 해결

### DNS 쿼리 실패
- 클러스터 호스트가 올바른지 확인
- 클러스터가 완전히 생성되었는지 확인

### 인증 실패
- 사용자 이름과 비밀번호 확인
- Database Access에서 사용자 존재 확인

### 타임아웃
- 네트워크 접근 확인 (0.0.0.0/0)
- 클러스터 상태 확인

---

**클러스터 호스트를 확인한 후 연결 테스트를 실행하세요!**

