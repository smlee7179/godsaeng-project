# 🔧 MongoDB SSL 오류 순차적 해결 단계

## ⚠️ 가장 중요: MongoDB Atlas 네트워크 액세스 확인

### 1단계: 네트워크 액세스 설정 확인 (최우선)

**문제**: Render 서버의 IP 주소가 MongoDB Atlas에 허용되지 않으면 연결 자체가 불가능합니다.

**해결 방법**:
1. MongoDB Atlas 대시보드 접속: https://cloud.mongodb.com
2. 프로젝트 선택 → "Network Access" 메뉴 클릭
3. "Add IP Address" 버튼 클릭
4. 다음 중 선택:
   - **개발용 (권장)**: "Allow Access from Anywhere" 선택
     - IP Address: `0.0.0.0/0`
     - Comment: "Render deployment"
   - **프로덕션용**: Render 서비스의 실제 IP 주소 추가
5. "Confirm" 클릭
6. **중요**: 변경사항이 적용되기까지 최대 5분 소요될 수 있습니다.

**체크리스트**:
- [ ] MongoDB Atlas 네트워크 액세스 페이지 접속
- [ ] "Add IP Address" 클릭
- [ ] "0.0.0.0/0" 또는 Render IP 추가
- [ ] 변경사항 저장 및 적용 대기 (최대 5분)

---

## 2단계: 연결 문자열 확인 및 테스트

### 현재 연결 문자열 확인

```
mongodb+srv://smlee2257_db_user:MJBdSMaeBvSKgcZy@cluster0.zlcflwi.mongodb.net/godsaeng?retryWrites=true&w=majority
```

### MongoDB Atlas에서 최신 연결 문자열 가져오기

1. MongoDB Atlas 대시보드 접속
2. "Connect" 버튼 클릭
3. "Connect your application" 선택
4. "Driver: Python" 선택
5. "Version: 3.6 or later" 선택
6. 연결 문자열 복사
7. 비밀번호만 현재 비밀번호로 교체

**체크리스트**:
- [ ] MongoDB Atlas에서 최신 연결 문자열 확인
- [ ] 연결 문자열이 정확한지 확인
- [ ] 비밀번호가 올바른지 확인

---

## 3단계: 코드 단순화 (현재 적용됨)

**구현된 방법**: 순차적 재시도 로직

1. **첫 번째 시도**: 최소 설정 (연결 문자열만)
2. **두 번째 시도**: `tlsAllowInvalidCertificates` 파라미터 추가
3. **세 번째 시도**: 최소 설정으로 재시도

이 방법으로 다양한 환경에서 작동할 가능성이 높습니다.

---

## 4단계: PyMongo/Motor 버전 업그레이드 (선택사항)

만약 위 방법들이 작동하지 않으면:

```python
# requirements.txt 수정
pymongo>=4.8.0  # 최신 버전
motor>=3.3.5    # 최신 버전
```

**주의**: 버전 업그레이드는 호환성 문제를 일으킬 수 있으므로 신중하게 진행하세요.

---

## 5단계: mongodb:// 형식으로 변환 (최후의 수단)

만약 `mongodb+srv://`가 계속 문제를 일으키면:

```python
# mongodb+srv://를 mongodb://로 변환
# 주의: 실제 클러스터 호스트명 필요
mongodb_url = "mongodb://smlee2257_db_user:MJBdSMaeBvSKgcZy@ac-y5mtsl2-shard-00-00.zlcflwi.mongodb.net:27017,ac-y5mtsl2-shard-00-01.zlcflwi.mongodb.net:27017,ac-y5mtsl2-shard-00-02.zlcflwi.mongodb.net:27017/godsaeng?ssl=true&replicaSet=atlas-xxxxxx-shard-0&authSource=admin&retryWrites=true&w=majority"
```

---

## 🎯 권장 해결 순서

1. **1단계 (필수)**: MongoDB Atlas 네트워크 액세스 설정 확인
2. **2단계 (필수)**: 연결 문자열 정확성 확인
3. **3단계 (자동)**: 현재 코드가 순차적으로 재시도 (이미 구현됨)
4. **4단계 (선택)**: PyMongo 버전 업그레이드
5. **5단계 (최후)**: mongodb:// 형식으로 변환

---

## 📋 체크리스트

### 필수 확인 사항:
- [ ] **1단계**: MongoDB Atlas 네트워크 액세스에 Render IP 또는 0.0.0.0/0 추가됨
- [ ] **2단계**: 연결 문자열이 MongoDB Atlas에서 복사한 최신 버전임
- [ ] **3단계**: 환경 변수 MONGODB_URL이 Render에 올바르게 설정됨

### 추가 시도 사항:
- [ ] **4단계**: PyMongo/Motor 버전 업그레이드 시도
- [ ] **5단계**: mongodb:// 형식으로 변환 시도

---

## 💡 디버깅 팁

### 연결 오류 로그 확인
Render 대시보드의 로그에서:
- `SSL handshake failed`: 네트워크 액세스 또는 인증서 문제
- `Authentication failed`: 사용자 이름/비밀번호 문제
- `DNS resolution failed`: 클러스터 호스트명 문제
- `Connection timeout`: 네트워크 액세스 문제

### 로컬에서 테스트
```bash
python3 test-mongodb-connection.py
```

---

**가장 중요한 것은 1단계: MongoDB Atlas 네트워크 액세스 설정입니다!** ⚠️

대부분의 SSL 핸드셰이크 오류는 네트워크 액세스 설정 문제입니다.

