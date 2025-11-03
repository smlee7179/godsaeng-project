# 🔧 MongoDB SSL 핸드셰이크 오류 순차적 해결 방법

## 📋 문제 해결 체크리스트

### 1단계: 기본 연결 문자열 확인

**현재 연결 문자열**:
```
mongodb+srv://smlee2257_db_user:MJBdSMaeBvSKgcZy@cluster0.zlcflwi.mongodb.net/godsaeng?retryWrites=true&w=majority
```

**확인 사항**:
- ✅ 사용자 이름 정확한가?
- ✅ 비밀번호 정확한가?
- ✅ 클러스터 호스트명 정확한가?
- ✅ 데이터베이스 이름 정확한가?

**테스트 방법**:
```bash
# MongoDB Atlas 대시보드에서 연결 문자열 복사
# "Connect" → "Connect your application" → "Driver: Python" → "Version: 3.6 or later"
```

---

### 2단계: MongoDB Atlas 네트워크 액세스 확인 ⚠️ 중요

**문제**: Render 서버의 IP 주소가 허용되지 않았을 수 있음

**해결 방법**:
1. MongoDB Atlas 대시보드 접속
2. "Network Access" 메뉴 클릭
3. "Add IP Address" 클릭
4. 다음 중 선택:
   - **방법 1**: "Allow Access from Anywhere" (0.0.0.0/0) - 개발용
   - **방법 2**: Render 서비스의 IP 주소 추가 (프로덕션용)

**체크리스트**:
- [ ] MongoDB Atlas 네트워크 액세스에 Render IP 추가됨
- [ ] 또는 "0.0.0.0/0" (모든 IP) 허용됨
- [ ] 네트워크 액세스 상태가 "Active"임

---

### 3단계: 연결 문자열 옵션 수정

**현재 문제**: `tlsAllowInvalidCertificates`가 작동하지 않을 수 있음

**해결 방법**: 최소한의 옵션만 사용

**수정 전**:
```
mongodb+srv://...?retryWrites=true&w=majority&tlsAllowInvalidCertificates=true
```

**수정 후 (시도 1)**:
```
mongodb+srv://...?retryWrites=true&w=majority
```
→ `mongodb+srv://`는 기본적으로 TLS 사용하므로 추가 옵션 불필요

**수정 후 (시도 2)**:
```
mongodb+srv://...?retryWrites=true&w=majority&tls=true&ssl=true
```

---

### 4단계: PyMongo/Motor 버전 확인 및 업그레이드

**현재 버전**:
- pymongo==4.6.0
- motor==3.3.2

**문제**: 오래된 버전이 SSL 설정을 제대로 처리하지 못할 수 있음

**해결 방법**: 최신 버전으로 업그레이드

```python
# requirements.txt 수정
pymongo>=4.8.0  # 최신 버전
motor>=3.3.5    # 최신 버전
```

---

### 5단계: 연결 방법 단순화

**현재 코드**: 복잡한 조건부 설정

**해결 방법**: 최소한의 설정으로 단순화

```python
# 가장 간단한 방법
client = AsyncIOMotorClient(mongodb_url)
```

**만약 실패한다면**:
```python
# 연결 문자열만 수정
mongodb_url = mongodb_url.replace(
    "?retryWrites=true&w=majority",
    "?retryWrites=true&w=majority&tlsAllowInvalidCertificates=true"
)
client = AsyncIOMotorClient(mongodb_url)
```

---

### 6단계: mongodb:// 형식으로 변환

**문제**: `mongodb+srv://`가 DNS SRV 레코드를 사용하는데, 이 과정에서 SSL 문제 발생 가능

**해결 방법**: `mongodb://` 형식으로 변환

```python
# mongodb+srv://를 mongodb://로 변환
# 주의: 클러스터의 실제 호스트명을 사용해야 함
mongodb_url = mongodb_url.replace(
    "mongodb+srv://",
    "mongodb://"
).replace(
    "@cluster0.zlcflwi.mongodb.net/",
    "@ac-y5mtsl2-shard-00-00.zlcflwi.mongodb.net:27017,ac-y5mtsl2-shard-00-01.zlcflwi.mongodb.net:27017,ac-y5mtsl2-shard-00-02.zlcflwi.mongodb.net:27017/"
)

# SSL 옵션 추가
mongodb_url += "?ssl=true&sslAllowInvalidCertificates=true&retryWrites=true&w=majority"
```

---

### 7단계: 연결 문자열에서 직접 테스트

**로컬에서 연결 테스트**:
```python
# test-connection.py
import asyncio
from motor.motor_asyncio import AsyncIOMotorClient

async def test():
    url = "mongodb+srv://smlee2257_db_user:MJBdSMaeBvSKgcZy@cluster0.zlcflwi.mongodb.net/godsaeng?retryWrites=true&w=majority"
    
    try:
        client = AsyncIOMotorClient(url)
        result = await client.admin.command('ping')
        print(f"✅ 연결 성공: {result}")
    except Exception as e:
        print(f"❌ 연결 실패: {e}")

asyncio.run(test())
```

---

### 8단계: 최소 설정으로 재시도

**가장 단순한 설정**:
1. 연결 문자열만 사용
2. 추가 파라미터 제거
3. 기본값 사용

```python
# 최소 설정
mongodb_url = os.getenv("MONGODB_URL")
client = AsyncIOMotorClient(mongodb_url)
db = client[settings.database_name]
await client.admin.command('ping')
```

---

### 9단계: 환경 변수 확인

**Render 환경 변수 확인**:
- [ ] MONGODB_URL이 정확하게 설정되어 있나?
- [ ] 연결 문자열에 특수문자가 올바르게 인코딩되어 있나?
- [ ] 환경 변수 값에 공백이나 잘못된 문자가 없나?

---

### 10단계: 대안 - 연결 재시도 로직 추가

**문제**: 일시적인 네트워크 문제일 수 있음

**해결 방법**: 재시도 로직 추가

```python
import asyncio

async def init_db_with_retry(max_retries=3):
    for i in range(max_retries):
        try:
            client = AsyncIOMotorClient(mongodb_url)
            await client.admin.command('ping')
            return client
        except Exception as e:
            if i == max_retries - 1:
                raise
            await asyncio.sleep(2 ** i)  # 지수 백오프
```

---

## 🎯 권장 해결 순서

1. **먼저 시도**: MongoDB Atlas 네트워크 액세스 확인 (2단계)
2. **두 번째**: 연결 문자열 단순화 (3단계)
3. **세 번째**: 최소 설정으로 테스트 (8단계)
4. **네 번째**: PyMongo 버전 업그레이드 (4단계)
5. **다섯 번째**: mongodb:// 형식으로 변환 (6단계)

---

## 📝 체크리스트 요약

- [ ] 1단계: 연결 문자열 정확성 확인
- [ ] 2단계: MongoDB Atlas 네트워크 액세스 설정 확인 ⚠️ 중요
- [ ] 3단계: 연결 문자열 옵션 단순화
- [ ] 4단계: PyMongo/Motor 버전 업그레이드
- [ ] 5단계: 연결 코드 단순화
- [ ] 6단계: mongodb:// 형식으로 변환 시도
- [ ] 7단계: 로컬에서 연결 테스트
- [ ] 8단계: 최소 설정으로 재시도
- [ ] 9단계: 환경 변수 확인
- [ ] 10단계: 재시도 로직 추가

---

**가장 중요한 것은 2단계: MongoDB Atlas 네트워크 액세스 설정입니다!**

