# 📋 프론트엔드 서비스 생성 가이드

## 🎯 목표
Render에서 프론트엔드 서비스를 Static Site로 생성

## ✅ 준비 완료 사항
- ✅ render.yaml에 프론트엔드 서비스 설정 포함
- ✅ frontend/package.json 존재
- ✅ frontend/vite.config.js 존재
- ✅ 빌드 스크립트 준비 완료
- ✅ 환경 변수 설정 완료

## 🚀 프론트엔드 서비스 생성 방법

### 방법 1: Blueprint을 통한 자동 생성 (권장)

1. **Render 대시보드 접속**
   - https://dashboard.render.com

2. **Blueprints 메뉴**
   - 왼쪽 메뉴에서 "Blueprints" 선택
   - GitHub 저장소에서 render.yaml 사용

3. **새 Blueprint 생성**
   - "New Blueprint" 클릭
   - GitHub 저장소 선택: `smlee7179/godsaeng-project`
   - render.yaml 파일 자동 감지
   - "Apply" 클릭

4. **서비스 자동 생성**
   - render.yaml의 모든 서비스가 자동 생성됨
   - 백엔드 + 프론트엔드 모두 생성

### 방법 2: 수동으로 Static Site 생성

1. **Render 대시보드 접속**
   - https://dashboard.render.com

2. **New Static Site 클릭**
   - "New" 버튼 클릭
   - "Static Site" 선택

3. **GitHub 저장소 연결**
   - Repository: `smlee7179/godsaeng-project`
   - Branch: `main`

4. **빌드 설정**
   - **Name**: `godsaeng-frontend`
   - **Root Directory**: `frontend`
   - **Build Command**: `npm install && npm run build`
   - **Publish Directory**: `dist`

5. **환경 변수 설정**
   - `VITE_API_BASE_URL` = `https://godsaeng-backend.onrender.com`

6. **생성**
   - "Create Static Site" 클릭

## 📋 서비스 설정 요약

```
Name: godsaeng-frontend
Type: Static Site
Root Directory: frontend
Build Command: npm install && npm run build
Publish Directory: dist
Environment Variables:
  - VITE_API_BASE_URL: https://godsaeng-backend.onrender.com
```

## ⚠️ 주의사항

1. **백엔드 서비스가 먼저 배포되어야 함**
   - 프론트엔드의 `VITE_API_BASE_URL`이 백엔드 URL을 참조
   - 백엔드가 정상 작동하는지 확인

2. **환경 변수 설정 필수**
   - `VITE_API_BASE_URL`을 반드시 설정
   - 설정하지 않으면 로컬호스트를 사용하게 됨

3. **빌드 시간**
   - 첫 빌드는 5-10분 소요 가능
   - 무료 플랜은 빌드 시간이 더 오래 걸릴 수 있음

## ✅ 생성 후 확인

1. **서비스 상태 확인**
   - Render 대시보드에서 서비스 상태 확인
   - "Live" 상태가 될 때까지 대기

2. **URL 확인**
   - 생성된 서비스의 URL 확인
   - 예: `https://godsaeng-frontend.onrender.com`

3. **접속 테스트**
   - 브라우저에서 URL 접속
   - 정상적으로 로드되는지 확인

---

**현재 상태**: 프론트엔드 서비스 카드 미생성
**권장 조치**: Render 대시보드에서 Static Site 수동 생성 또는 Blueprint 재배포

