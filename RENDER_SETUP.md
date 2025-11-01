# 📝 Render 배포 체크리스트

## ✅ 배포 전 확인사항

### 1. Git 저장소
- [ ] GitHub 저장소 생성 완료
- [ ] 코드 푸시 완료 (`git push`)

### 2. MongoDB Atlas
- [ ] 계정 생성 완료
- [ ] 무료 클러스터 생성 완료 (M0)
- [ ] 데이터베이스 사용자 생성 완료
- [ ] 네트워크 접근: 0.0.0.0/0 허용 완료
- [ ] 연결 문자열 복사 완료

### 3. Render 계정
- [ ] Render 계정 생성 완료 (GitHub 연동)

### 4. 환경 변수 준비
백엔드 환경 변수:
```
MONGODB_URL=mongodb+srv://user:pass@cluster0.xxxxx.mongodb.net/godsaeng?retryWrites=true&w=majority
DATABASE_NAME=godsaeng
JWT_SECRET_KEY=your-secret-key-here-min-32-chars
ACCESS_TOKEN_EXPIRE_MINUTES=30
AI_PROVIDER=huggingface
HUGGINGFACE_API_KEY=optional
GEMINI_API_KEY=optional
```

프론트엔드 환경 변수:
```
VITE_API_BASE_URL=https://godsaeng-backend.onrender.com
```

## 🚀 배포 단계

### Step 1: 백엔드 배포
1. Render Dashboard → New + → Web Service
2. GitHub 저장소 연결
3. 설정 값 입력 (위 체크리스트 참고)
4. 환경 변수 입력
5. Create Web Service

### Step 2: 프론트엔드 배포
1. Render Dashboard → New + → Static Site
2. 같은 GitHub 저장소 연결
3. 설정 값 입력
4. 환경 변수에 백엔드 URL 입력
5. Create Static Site

### Step 3: 대기
- 배포 완료까지 5-10분 소요
- Logs 탭에서 진행 상황 확인

## 🔍 배포 후 확인

- [ ] 백엔드 URL 접속 가능
- [ ] API 문서 접속 가능 (`/docs`)
- [ ] 프론트엔드 URL 접속 가능
- [ ] 프론트엔드에서 백엔드 API 호출 성공

## ⚠️ 주의사항

1. **무료 티어 제한**
   - 15분 미사용 시 자동 스핀다운
   - 첫 요청 시 30초 지연 가능
   - 월 750시간 제한

2. **MongoDB Atlas 제한**
   - 512MB 저장공간 제한
   - 동시 연결 제한

3. **자동 배포**
   - GitHub 푸시 시 자동 재배포
   - 수동 배포도 가능 (Dashboard → Manual Deploy)

## 🐛 문제 해결

### 백엔드 배포 실패
- 로그 확인: Dashboard → 서비스 → Logs
- 환경 변수 확인
- MongoDB 연결 문자열 확인
- Python 버전 확인 (3.9.18 권장)

### 프론트엔드 배포 실패
- 빌드 로그 확인
- 환경 변수 확인
- Node.js 버전 확인

### API 연결 실패
- CORS 설정 확인
- `VITE_API_BASE_URL` 환경 변수 확인
- 백엔드 URL이 올바른지 확인

