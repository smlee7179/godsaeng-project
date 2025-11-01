# 🌐 GODSAENG 클라우드 배포 가이드

이 프로젝트는 **Render** (무료 클라우드 플랫폼)에 배포할 수 있습니다.

## 🎯 빠른 시작

1. **5분 빠른 배포**: `QUICK_DEPLOY.md` 참고
2. **상세 가이드**: `DEPLOY_RENDER.md` 참고
3. **체크리스트**: `RENDER_SETUP.md` 참고
4. **배포 스크립트**: `./deploy-to-render.sh`

## 📚 배포 문서

| 문서 | 설명 |
|---|---|
| `QUICK_DEPLOY.md` | 5분 빠른 배포 가이드 |
| `DEPLOY_RENDER.md` | 상세 배포 가이드 |
| `RENDER_SETUP.md` | 배포 체크리스트 |

## 🚀 배포 방법

### 방법 1: 자동 스크립트 (권장)

```bash
./deploy-to-render.sh
```

### 방법 2: 수동 배포

1. **GitHub에 코드 푸시**
2. **MongoDB Atlas 설정** (`DEPLOY_RENDER.md` 참고)
3. **Render에서 배포** (`QUICK_DEPLOY.md` 참고)

## 🌍 배포 후 접속

배포 완료 후:
- **프론트엔드**: `https://your-app.onrender.com`
- **백엔드 API**: `https://your-backend.onrender.com`
- **API 문서**: `https://your-backend.onrender.com/docs`

## ⚙️ 환경 변수

### 백엔드 (필수)
- `MONGODB_URL`: MongoDB Atlas 연결 문자열
- `DATABASE_NAME`: `godsaeng`
- `JWT_SECRET_KEY`: 임의의 긴 문자열 (보안)

### 프론트엔드 (필수)
- `VITE_API_BASE_URL`: 백엔드 URL

자세한 내용은 `DEPLOY_RENDER.md`를 참고하세요.

## 💡 왜 Render?

- ✅ **완전 무료**: 백엔드 + 프론트엔드 모두 무료
- ✅ **쉬운 배포**: GitHub 연동으로 자동 배포
- ✅ **빠른 설정**: 5분 안에 배포 가능
- ✅ **HTTPS 지원**: 자동 SSL 인증서

## 🔧 문제 해결

배포 중 문제가 발생하면:
1. `DEPLOY_RENDER.md`의 "문제 해결" 섹션 확인
2. Render 로그 확인 (Dashboard → Logs)
3. 환경 변수 확인

