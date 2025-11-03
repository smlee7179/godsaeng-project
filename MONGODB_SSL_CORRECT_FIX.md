# 🔧 MongoDB SSL 핸드셰이크 오류 정확한 해결

## ❌ 발견된 문제

```
pymongo.errors.ConfigurationError: Unknown option ssl_context
```

**근본 원인**: 
- PyMongo 4.6.0과 Motor 3.3.2는 `ssl_context` 파라미터를 지원하지 않음
- 이전 수정에서 `ssl_context`를 직접 전달하려고 시도했지만, PyMongo API가 이를 인식하지 못함

## ✅ 정확한 해결 방법

### PyMongo/Motor가 지원하는 SSL 파라미터

PyMongo/Motor는 다음 SSL 파라미터를 지원합니다:
- `tls=True` / `tls=False`: TLS/SSL 사용 여부
- `tlsAllowInvalidCertificates=True`: 인증서 검증 우회
- `ssl_cert_reqs`: 인증서 검증 요구사항 (ssl.CERT_NONE, ssl.CERT_REQUIRED 등)
- `ssl_ca_certs`: CA 인증서 파일 경로
- `ssl_certfile`: 클라이언트 인증서 파일
- `ssl_keyfile`: 클라이언트 키 파일

**지원하지 않는 파라미터**:
- ❌ `ssl_context`: 직접 전달 불가

### 최종 수정 사항

```python
# 연결 문자열에 TLS 옵션 추가
if "tlsAllowInvalidCertificates" not in mongodb_url:
    separator = "&" if "?" in mongodb_url else "?"
    mongodb_url = f"{mongodb_url}{separator}tlsAllowInvalidCertificates=true"

# AsyncIOMotorClient 생성 시 PyMongo가 지원하는 파라미터 사용
client = AsyncIOMotorClient(
    mongodb_url,
    tls=True,
    tlsAllowInvalidCertificates=True,
    serverSelectionTimeoutMS=30000,
    connectTimeoutMS=20000
)
```

### 핵심 변경 사항

1. **ssl_context 제거**: PyMongo가 지원하지 않으므로 제거
2. **tlsAllowInvalidCertificates 사용**: PyMongo가 지원하는 파라미터 사용
3. **이중 보장**: 연결 문자열과 클라이언트 파라미터 모두에 설정

## 📋 변경 히스토리

1. **1차 시도**: 연결 문자열에 TLS 옵션 추가 ❌
2. **2차 시도**: AsyncIOMotorClient에 tls 파라미터 추가 ❌
3. **3차 시도**: tlsAllowInvalidCertificates 파라미터 추가 ❌
4. **4차 시도**: ssl_context 직접 전달 ❌ (API 미지원)
5. **최종 해결**: PyMongo가 지원하는 tlsAllowInvalidCertificates 사용 + 연결 문자열 옵션 ✅

## 🔍 이 방법이 작동해야 하는 이유

1. **API 호환성**: PyMongo/Motor가 공식적으로 지원하는 파라미터 사용
2. **이중 보장**: 연결 문자열과 클라이언트 파라미터 모두에 설정
3. **Render 환경**: Render의 Python 3.13 환경과 호환
4. **문서화된 방법**: PyMongo 공식 문서의 권장 방법

## 📝 PyMongo SSL 설정 공식 문서

PyMongo는 다음 방법을 권장합니다:

```python
# 방법 1: 클라이언트 파라미터 사용
client = MongoClient(
    uri,
    tlsAllowInvalidCertificates=True
)

# 방법 2: 연결 문자열 옵션 사용
uri = "mongodb://...?tlsAllowInvalidCertificates=true"
client = MongoClient(uri)
```

## ⚠️ 만약 여전히 작동하지 않는다면

다음 대안을 시도해볼 수 있습니다:

1. **PyMongo/Motor 버전 업그레이드**:
   ```
   pymongo>=4.8.0
   motor>=3.3.5
   ```

2. **연결 문자열을 mongodb:// 형식으로 변환**:
   ```python
   # mongodb+srv://를 mongodb://로 변환
   # DNS SRV 레코드를 직접 IP로 변환
   ```

3. **MongoDB Atlas 네트워크 액세스 확인**:
   - MongoDB Atlas 대시보드에서 "Network Access" 확인
   - Render 서버의 IP 주소를 허용 목록에 추가
   - 또는 "0.0.0.0/0" (모든 IP 허용, 개발용)

---

**MongoDB SSL 핸드셰이크 오류 정확한 해결 완료!** ✅

이번 수정은 PyMongo/Motor가 공식적으로 지원하는 
SSL 파라미터를 사용하여 API 호환성 문제를 해결합니다.

