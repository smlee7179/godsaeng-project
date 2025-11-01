# 🤖 무료 AI API 설정 가이드

GODSAENG은 여러 무료 AI API를 지원합니다. 이 가이드를 따라 원하는 무료 AI 서비스를 설정하세요.

## 지원하는 AI 제공자

### 1. Hugging Face (권장 - 무료)
- ✅ 완전 무료 티어 제공
- ✅ API 키 없이도 사용 가능 (제한적)
- ✅ 다양한 오픈소스 모델 사용 가능

### 2. Google Gemini (무료 티어)
- ✅ 무료 티어 제공
- ✅ 우수한 성능
- ✅ API 키 필요

### 3. Ollama (완전 무료 - 로컬)
- ✅ 완전 무료 (로컬 실행)
- ✅ 인터넷 불필요
- ✅ 프라이버시 보호

### 4. OpenAI (유료)
- 💰 유료 (최소 요금 있음)
- ✅ 최고 성능

## 설정 방법

### 방법 1: Hugging Face (가장 간단)

#### 옵션 A: API 키 없이 사용 (제한적)
```bash
# .env 파일
AI_PROVIDER=huggingface
# HUGGINGFACE_API_KEY는 비워두면 됨
```

#### 옵션 B: API 키 발급 (무료, 더 나은 성능)

1. Hugging Face 계정 생성: https://huggingface.co/join
2. API 키 발급: https://huggingface.co/settings/tokens
3. `Read` 권한으로 토큰 생성

4. 설정 파일에 추가:

**backend/config/secrets.json**:
```json
{
  "HUGGINGFACE_API_KEY": "hf_your_api_key_here"
}
```

또는 **.env 파일**:
```env
AI_PROVIDER=huggingface
HUGGINGFACE_API_KEY=hf_your_api_key_here
```

### 방법 2: Google Gemini (무료 티어)

1. Google AI Studio 접속: https://makersuite.google.com/app/apikey
2. "Create API Key" 클릭
3. API 키 복사

4. 설정 파일에 추가:

**backend/config/secrets.json**:
```json
{
  "GEMINI_API_KEY": "your_gemini_api_key_here"
}
```

또는 **.env 파일**:
```env
AI_PROVIDER=gemini
GEMINI_API_KEY=your_gemini_api_key_here
```

5. Python 패키지 설치 (선택사항):
```bash
cd backend
pip install google-generativeai
```

### 방법 3: Ollama (완전 무료, 로컬)

Ollama는 로컬에서 AI 모델을 실행하는 도구입니다.

#### 설치

**macOS/Linux**:
```bash
curl -fsSL https://ollama.ai/install.sh | sh
```

**Windows**: https://ollama.ai/download/windows 에서 다운로드

#### 모델 다운로드

```bash
# Llama 3 모델 다운로드 (약 2GB)
ollama pull llama3

# 또는 더 작은 모델
ollama pull llama3.2
```

#### 서버 시작

```bash
# Ollama 서버 실행 (기본 포트: 11434)
ollama serve
```

#### 설정

**.env 파일**:
```env
AI_PROVIDER=ollama
OLLAMA_URL=http://localhost:11434
```

또는 **backend/config/settings.py**에서 이미 기본값으로 설정되어 있습니다.

### 방법 4: OpenAI (유료)

유료이지만 최고 성능을 원하는 경우:

1. OpenAI API 키 발급: https://platform.openai.com/api-keys
2. 설정 파일에 추가:

**backend/config/secrets.json**:
```json
{
  "OPENAI_API_KEY": "sk-your-api-key"
}
```

**.env 파일**:
```env
AI_PROVIDER=openai
OPENAI_API_KEY=sk-your-api-key
```

## 환경 변수 설정

### Docker Compose 사용 시

**docker-compose.yml**에 환경 변수 추가:

```yaml
backend:
  environment:
    - AI_PROVIDER=huggingface
    - HUGGINGFACE_API_KEY=${HUGGINGFACE_API_KEY:-}
    # 또는
    - AI_PROVIDER=gemini
    - GEMINI_API_KEY=${GEMINI_API_KEY:-}
    # 또는
    - AI_PROVIDER=ollama
    - OLLAMA_URL=http://localhost:11434
```

**.env 파일**에 실제 키 값 추가:
```env
AI_PROVIDER=huggingface
HUGGINGFACE_API_KEY=hf_your_key_here
```

## 테스트

설정 후 서버를 재시작하고 AI 분석 기능을 테스트하세요:

1. 웹 애플리케이션에서 기록 작성
2. AI 분석 페이지에서 날짜 선택
3. "새로 분석하기" 클릭

## 성능 비교

| 제공자 | 무료 | 성능 | 설정 난이도 | 권장도 |
|--------|------|------|------------|--------|
| Hugging Face | ✅ 완전 무료 | ⭐⭐⭐ | ⭐⭐⭐ 매우 쉬움 | ⭐⭐⭐⭐⭐ |
| Gemini | ✅ 무료 티어 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ 쉬움 | ⭐⭐⭐⭐ |
| Ollama | ✅ 완전 무료 | ⭐⭐⭐ | ⭐⭐ 보통 | ⭐⭐⭐⭐ |
| OpenAI | ❌ 유료 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ 쉬움 | ⭐⭐⭐ |

## 문제 해결

### Hugging Face 오류

- **503 오류**: 모델이 로딩 중입니다. 잠시 후 다시 시도하세요.
- **API 키 오류**: API 키가 올바른지 확인하세요.

### Gemini 오류

- **패키지 누락**: `pip install google-generativeai` 실행
- **API 키 오류**: API 키가 올바른지 확인하세요.

### Ollama 오류

- **연결 오류**: Ollama가 실행 중인지 확인: `ollama list`
- **모델 없음**: 모델 다운로드: `ollama pull llama3`

## 권장 설정

**가장 간단한 방법 (API 키 없음)**:
```env
AI_PROVIDER=huggingface
```

**더 나은 성능 (API 키 발급)**:
```env
AI_PROVIDER=huggingface
HUGGINGFACE_API_KEY=hf_your_key_here
```

**최고의 프라이버시 (로컬 실행)**:
```env
AI_PROVIDER=ollama
OLLAMA_URL=http://localhost:11434
```

