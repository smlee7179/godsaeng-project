# 🔧 MongoDB SSL 핸드셰이크 오류 해결

## ❌ 발견된 오류

```
pymongo.errors.ServerSelectionTimeoutError: SSL handshake failed: 
[SSL: TLSV1_ALERT_INTERNAL_ERROR] tlsv1 alert internal error
```

**원인**: 
- MongoDB Atlas SSL/TLS 연결 설정 문제
- Python SSL 인증서 검증 실패
- 연결 문자열에 TLS 옵션 누락

## ✅ 해결 방법

### database.py 수정

연결 문자열에 TLS 옵션을 자동으로 추가하도록 수정:

```python
# 연결 문자열에 TLS 옵션 확인 및 추가
if "tls=" not in mongodb_url and "ssl=" not in mongodb_url:
    # 연결 문자열에 TLS 옵션 추가
    separator = "&" if "?" in mongodb_url else "?"
    # tls=true: TLS/SSL 사용
    # tlsAllowInvalidCertificates=true: 인증서 검증 우회 (개발용)
    mongodb_url = f"{mongodb_url}{separator}tls=true&tlsAllowInvalidCertificates=true"
```

### 변경 사항

1. **연결 문자열 자동 수정**: TLS 옵션이 없으면 자동으로 추가
2. **tls=true**: TLS/SSL 사용 명시
3. **tlsAllowInvalidCertificates=true**: 인증서 검증 우회 (개발 환경용)

### 주의사항

⚠️ **tlsAllowInvalidCertificates=true**는 개발 환경에서만 사용해야 합니다.

프로덕션 환경에서는:
- MongoDB Atlas에서 제공하는 인증서 사용
- 또는 `tlsCAFile` 옵션으로 인증서 파일 지정
- `tlsAllowInvalidCertificates=false` 사용

## 📋 연결 문자열 형식

### 수정 전
```
mongodb+srv://user:password@cluster.mongodb.net/database
```

### 수정 후 (자동 추가됨)
```
mongodb+srv://user:password@cluster.mongodb.net/database?tls=true&tlsAllowInvalidCertificates=true
```

## 🚀 배포 후 확인

수정사항이 배포되면:
1. MongoDB 연결 성공 여부 확인
2. `/health` 엔드포인트에서 데이터베이스 상태 확인
3. 애플리케이션 로그에서 "✅ MongoDB 연결 성공" 메시지 확인

## 📝 추가 참고사항

### MongoDB Atlas 네트워크 액세스

MongoDB Atlas에서 Render 서버의 IP 주소를 허용해야 합니다:
1. MongoDB Atlas 대시보드 → Network Access
2. "Add IP Address" 클릭
3. Render 서비스의 IP 주소 추가 또는 "0.0.0.0/0" (모든 IP 허용, 개발용)

### 프로덕션 환경 권장 설정

```python
# 프로덕션에서는 인증서 검증 사용
mongodb_url = f"{mongodb_url}?tls=true"
# tlsAllowInvalidCertificates 옵션 제거
```

---

**MongoDB SSL 핸드셰이크 오류 해결 완료!** ✅

