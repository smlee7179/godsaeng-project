# 🚀 GODSAENG 빠른 시작 가이드

## 1분 안에 시작하기

### 필수 사항
- Docker 설치: https://docs.docker.com/get-docker/
- Docker Compose 설치 (보통 Docker와 함께 포함됨)

### 실행 단계

```bash
# 1. 프로젝트 디렉토리로 이동
cd GODSAENG_PROJECT

# 2. 배포 스크립트 실행
./deploy.sh

# 또는 직접 실행
docker-compose up -d
```

### 접속

- 🌐 **웹 애플리케이션**: http://localhost
- 🔌 **API 서버**: http://localhost:8000
- 📚 **API 문서**: http://localhost:8000/docs

### 첫 사용

1. 웹 브라우저에서 http://localhost 접속
2. "회원가입" 클릭
3. 이름, 이메일, 비밀번호 입력
4. 로그인 후 기록 작성 시작!

### 서비스 중지

```bash
docker-compose down
```

### 문제 해결

#### 포트가 이미 사용 중인 경우

`docker-compose.yml` 파일에서 포트 변경:

```yaml
ports:
  - "8080:80"      # 프론트엔드
  - "8001:8000"    # 백엔드
```

#### 로그 확인

```bash
docker-compose logs -f
```

#### 완전 초기화

```bash
docker-compose down -v
./deploy.sh
```

## 환경 변수 설정 (선택사항)

### OpenAI API 키 (AI 분석 기능)

1. OpenAI에서 API 키 발급: https://platform.openai.com/api-keys
2. `.env` 파일에 추가:
   ```env
   OPENAI_API_KEY=sk-...
   ```
3. 또는 `backend/config/secrets.json`에 추가:
   ```json
   {
     "OPENAI_API_KEY": "sk-..."
   }
   ```

### JWT 시크릿 키 변경

`.env` 파일 또는 `backend/config/secrets.json`에서 `JWT_SECRET_KEY` 변경

⚠️ **프로덕션 환경에서는 반드시 강력한 키를 사용하세요!**

## 다음 단계

- [상세 배포 가이드](./DEPLOYMENT.md) 확인
- [프로젝트 README](./README.md) 읽기
- [API 문서](http://localhost:8000/docs) 확인

