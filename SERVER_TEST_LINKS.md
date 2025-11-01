# 🌐 서버 접근 테스트 링크

## 백엔드 서비스 (API)

**기본 URL**: https://godsaeng-backend.onrender.com

### 기본 엔드포인트

- **루트**: https://godsaeng-backend.onrender.com/
- **헬스체크**: https://godsaeng-backend.onrender.com/health
- **설정 정보**: https://godsaeng-backend.onrender.com/config

### API 문서

- **Swagger UI**: https://godsaeng-backend.onrender.com/docs
- **ReDoc**: https://godsaeng-backend.onrender.com/redoc
- **OpenAPI JSON**: https://godsaeng-backend.onrender.com/openapi.json

### 인증 API

- **회원가입**: `POST https://godsaeng-backend.onrender.com/api/auth/register`
- **로그인**: `POST https://godsaeng-backend.onrender.com/api/auth/login`
- **JSON 로그인**: `POST https://godsaeng-backend.onrender.com/api/auth/login-json`
- **사용자 정보**: `GET https://godsaeng-backend.onrender.com/api/auth/me` (인증 필요)

### 사용자 API

- **프로필 조회**: `GET https://godsaeng-backend.onrender.com/api/users/profile` (인증 필요)

### 라이프 기록 API

- **기록 생성**: `POST https://godsaeng-backend.onrender.com/api/logs` (인증 필요)
- **기록 목록**: `GET https://godsaeng-backend.onrender.com/api/logs` (인증 필요)
- **오늘 기록**: `GET https://godsaeng-backend.onrender.com/api/logs/today` (인증 필요)
- **기록 상세**: `GET https://godsaeng-backend.onrender.com/api/logs/{log_id}` (인증 필요)
- **기록 수정**: `PUT https://godsaeng-backend.onrender.com/api/logs/{log_id}` (인증 필요)
- **기록 삭제**: `DELETE https://godsaeng-backend.onrender.com/api/logs/{log_id}` (인증 필요)

### AI 리포트 API

- **리포트 생성**: `POST https://godsaeng-backend.onrender.com/api/ai/analyze` (인증 필요)
- **리포트 조회**: `GET https://godsaeng-backend.onrender.com/api/ai/report?target_date=YYYY-MM-DD` (인증 필요)
- **리포트 목록**: `GET https://godsaeng-backend.onrender.com/api/ai/reports` (인증 필요)

## 프론트엔드 서비스 (웹 애플리케이션)

**기본 URL**: https://godsaeng-frontend.onrender.com

### 페이지

- **메인**: https://godsaeng-frontend.onrender.com
- **로그인**: https://godsaeng-frontend.onrender.com/login
- **회원가입**: https://godsaeng-frontend.onrender.com/register
- **대시보드**: https://godsaeng-frontend.onrender.com/dashboard (인증 필요)
- **기록 목록**: https://godsaeng-frontend.onrender.com/logs (인증 필요)
- **기록 생성**: https://godsaeng-frontend.onrender.com/logs/create (인증 필요)
- **AI 리포트**: https://godsaeng-frontend.onrender.com/ai-reports (인증 필요)

## 빠른 테스트

### 1. 헬스체크 (웹 브라우저)

브라우저에서 직접 접근:
- https://godsaeng-backend.onrender.com/health

예상 응답:
```json
{
  "status": "healthy",
  "database": "connected",
  "version": "1.0.0"
}
```

### 2. API 문서 확인

Swagger UI로 모든 API를 테스트할 수 있습니다:
- https://godsaeng-backend.onrender.com/docs

### 3. 루트 엔드포인트

- https://godsaeng-backend.onrender.com/

예상 응답:
```json
{
  "message": "GODSAENG API 서버가 실행 중입니다.",
  "status": "healthy",
  "version": "1.0.0"
}
```

## 테스트 스크립트

자세한 테스트는 `test-server-links.sh` 스크립트를 사용하세요:

```bash
chmod +x test-server-links.sh
./test-server-links.sh
```

## 주의사항

⚠️ **무료 플랜 제한사항**:
- Render 무료 플랜은 서비스가 15분 이상 비활성 상태이면 자동으로 슬립 모드로 전환됩니다
- 첫 요청 시 서비스가 깨어나는 데 약 30초~1분 정도 소요될 수 있습니다
- 이는 정상적인 동작입니다

---

**서버 접근 테스트 링크 제공 완료!** ✅

