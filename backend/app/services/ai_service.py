"""
AI 서비스 - 여러 AI API 지원 (OpenAI, Hugging Face, Gemini, Ollama)
"""
from typing import List, Optional
from datetime import date
import json
import os
from app.config.settings import get_settings
from app.models.log import DailyLog

settings = get_settings()

class AIService:
    """AI 분석 서비스 - 여러 AI 제공자 지원"""
    
    def __init__(self):
        self.provider = os.getenv("AI_PROVIDER", "huggingface").lower()
        self.api_key = None
        self.client = None
        
        # 설정된 API 키 확인
        if self.provider == "openai":
            self.api_key = os.getenv("OPENAI_API_KEY") or settings.openai_api_key
            if self.api_key:
                try:
                    from openai import OpenAI
                    self.client = OpenAI(api_key=self.api_key)
                    print("✅ OpenAI API 사용")
                except ImportError:
                    print("⚠️ OpenAI 패키지가 설치되지 않았습니다.")
        elif self.provider == "huggingface":
            self.api_key = os.getenv("HUGGINGFACE_API_KEY") or settings.huggingface_api_key
            if self.api_key:
                print("✅ Hugging Face API 키 사용")
            else:
                print("💡 Hugging Face API 키 없음 - 무료 모델 사용 (제한적)")
        elif self.provider == "gemini":
            self.api_key = os.getenv("GEMINI_API_KEY") or settings.gemini_api_key
            if self.api_key:
                try:
                    import google.generativeai as genai
                    genai.configure(api_key=self.api_key)
                    self.client = genai
                    print("✅ Google Gemini API 사용")
                except ImportError:
                    print("⚠️ Google Generative AI 패키지가 설치되지 않았습니다.")
        elif self.provider == "ollama":
            self.ollama_url = os.getenv("OLLAMA_URL") or settings.ollama_url
            print(f"✅ Ollama 사용: {self.ollama_url}")
        else:
            # 기본값을 huggingface로
            self.provider = "huggingface"
            self.api_key = os.getenv("HUGGINGFACE_API_KEY") or settings.huggingface_api_key
            if not self.api_key:
                print("💡 Hugging Face API 키 없음 - 무료 모델 사용 (제한적)")
    
    async def analyze_daily_logs(self, logs: List[DailyLog], target_date: date) -> dict:
        """
        일일 기록들을 분석하여 요약 및 피드백 생성
        
        Args:
            logs: 분석할 일일 기록 리스트
            target_date: 분석 대상 날짜
            
        Returns:
            AI 분석 결과 딕셔너리
        """
        # 기록들을 텍스트로 변환
        log_texts = []
        for log in logs:
            log_entry = f"- {log.activity}"
            if log.mood:
                log_entry += f" (감정: {log.mood})"
            if log.tags:
                log_entry += f" [태그: {', '.join(log.tags)}]"
            log_texts.append(log_entry)
        
        logs_summary = "\n".join(log_texts) if log_texts else "기록이 없습니다."
        
        # 공통 프롬프트 생성
        prompt = f"""당신은 사용자의 일상을 분석하고 피드백을 제공하는 AI 어시스턴트입니다.

날짜: {target_date}
오늘의 활동 기록:
{logs_summary}

위 활동들을 바탕으로 다음을 작성해주세요:
1. 하루 요약 (2-3문장)
2. 감정 분석 (감정 키워드 3-5개)
3. 인사이트 (패턴이나 특징 2-3개)
4. 개선 제안 (추천사항 2-3개)

JSON 형식으로 응답해주세요:
{{
    "summary": "하루 요약",
    "emotions": ["감정1", "감정2"],
    "insights": ["인사이트1", "인사이트2"],
    "recommendations": ["추천1", "추천2"],
    "feedback": "전체적인 피드백 메시지"
}}"""

        # 제공자별 처리
        if self.provider == "openai":
            return await self._analyze_with_openai(prompt)
        elif self.provider == "huggingface":
            return await self._analyze_with_huggingface(prompt)
        elif self.provider == "gemini":
            return await self._analyze_with_gemini(prompt)
        elif self.provider == "ollama":
            return await self._analyze_with_ollama(prompt)
        else:
            return await self._analyze_with_huggingface(prompt)  # 기본값
    
    async def _analyze_with_openai(self, prompt: str) -> dict:
        """OpenAI API 사용"""
        if not self.client:
            return self._default_error_response("OpenAI API 키가 필요합니다.")
        
        try:
            response = self.client.chat.completions.create(
                model="gpt-4o-mini",
                messages=[
                    {"role": "system", "content": "당신은 사용자의 일상을 분석하는 AI 어시스턴트입니다. 한국어로 응답하세요."},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.7,
                max_tokens=1000
            )
            content = response.choices[0].message.content
            return self._parse_ai_response(content)
        except Exception as e:
            return self._default_error_response(f"OpenAI 오류: {str(e)}")
    
    async def _analyze_with_huggingface(self, prompt: str) -> dict:
        """Hugging Face Inference API 사용 (무료)"""
        try:
            import aiohttp
            
            # 무료 모델 사용 (API 키 불필요)
            model = "meta-llama/Meta-Llama-3.2-3B-Instruct"  # 무료 모델
            api_url = f"https://api-inference.huggingface.co/models/{model}"
            
            headers = {
                "Content-Type": "application/json",
            }
            
            if self.api_key:
                headers["Authorization"] = f"Bearer {self.api_key}"
            
            payload = {
                "inputs": f"""당신은 사용자의 일상을 분석하는 AI 어시스턴트입니다. 한국어로 응답하세요.

{prompt}""",
                "parameters": {
                    "max_new_tokens": 1000,
                    "temperature": 0.7,
                    "return_full_text": False
                }
            }
            
            async with aiohttp.ClientSession() as session:
                async with session.post(api_url, json=payload, headers=headers) as response:
                    if response.status == 200:
                        result = await response.json()
                        content = result[0].get("generated_text", "")
                        return self._parse_ai_response(content)
                    elif response.status == 503:
                        # 모델 로딩 중이면 더 간단한 모델 사용
                        return await self._analyze_with_simple_model(prompt)
                    else:
                        return self._default_error_response(f"Hugging Face API 오류: {response.status}")
        except ImportError:
            return await self._analyze_with_simple_model(prompt)
        except Exception as e:
            return await self._analyze_with_simple_model(prompt)
    
    async def _analyze_with_gemini(self, prompt: str) -> dict:
        """Google Gemini API 사용 (무료 티어)"""
        if not self.api_key:
            return self._default_error_response("Gemini API 키가 필요합니다.")
        
        try:
            import google.generativeai as genai
            
            model = genai.GenerativeModel('gemini-pro')
            response = model.generate_content(
                f"""당신은 사용자의 일상을 분석하는 AI 어시스턴트입니다. 한국어로 응답하세요.

{prompt}"""
            )
            content = response.text
            return self._parse_ai_response(content)
        except ImportError:
            return self._default_error_response("Google Generative AI 패키지가 설치되지 않았습니다.")
        except Exception as e:
            return self._default_error_response(f"Gemini 오류: {str(e)}")
    
    async def _analyze_with_ollama(self, prompt: str) -> dict:
        """Ollama 로컬 모델 사용 (완전 무료)"""
        try:
            import aiohttp
            
            api_url = f"{self.ollama_url}/api/generate"
            payload = {
                "model": "llama3",  # 또는 llama2, mistral 등
                "prompt": f"""당신은 사용자의 일상을 분석하는 AI 어시스턴트입니다. 한국어로 응답하세요.

{prompt}""",
                "stream": False
            }
            
            async with aiohttp.ClientSession() as session:
                async with session.post(api_url, json=payload) as response:
                    if response.status == 200:
                        result = await response.json()
                        content = result.get("response", "")
                        return self._parse_ai_response(content)
                    else:
                        return self._default_error_response("Ollama 서버에 연결할 수 없습니다. Ollama가 설치되어 실행 중인지 확인하세요.")
        except ImportError:
            return self._default_error_response("aiohttp 패키지가 필요합니다.")
        except Exception as e:
            return self._default_error_response(f"Ollama 오류: {str(e)}")
    
    async def _analyze_with_simple_model(self, prompt: str) -> dict:
        """간단한 규칙 기반 분석 (API 없이 작동)"""
        # 기본적인 분석 제공
        return {
            "summary": "오늘 하루를 기록하신 모든 활동이 소중합니다. 지속적인 기록을 통해 더 나은 인사이트를 얻을 수 있습니다.",
            "feedback": "규칙 기반 분석입니다. 더 정확한 AI 분석을 위해 Hugging Face API 키를 설정하거나 Ollama를 사용하세요.",
            "emotions": ["기록", "성장", "자기반성"],
            "insights": ["지속적인 기록의 가치", "패턴 관찰의 중요성"],
            "recommendations": ["더 많은 기록을 남겨보세요", "정기적으로 자신의 패턴을 확인해보세요"]
        }
    
    def _parse_ai_response(self, content: str) -> dict:
        """AI 응답을 파싱하여 구조화된 결과 반환"""
        try:
            # 코드 블록 제거
            if "```json" in content:
                content = content.split("```json")[1].split("```")[0].strip()
            elif "```" in content:
                content = content.split("```")[1].split("```")[0].strip()
            
            result = json.loads(content)
            return {
                "summary": result.get("summary", "분석을 완료했습니다."),
                "feedback": result.get("feedback", ""),
                "emotions": result.get("emotions", []),
                "insights": result.get("insights", []),
                "recommendations": result.get("recommendations", [])
            }
        except json.JSONDecodeError:
            # JSON 파싱 실패 시 텍스트에서 키워드 추출 시도
            summary = content[:300] + "..." if len(content) > 300 else content
            return {
                "summary": summary,
                "feedback": "AI 분석이 완료되었습니다.",
                "emotions": [],
                "insights": [],
                "recommendations": []
            }
    
    def _default_error_response(self, error_msg: str) -> dict:
        """기본 오류 응답"""
        return {
            "summary": error_msg,
            "feedback": "무료 AI 서비스를 사용하려면 설정을 확인하세요.",
            "emotions": [],
            "insights": [],
            "recommendations": []
        }

# 전역 인스턴스
ai_service = AIService()

