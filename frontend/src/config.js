// 환경에 따른 API URL 설정
const getApiBaseUrl = () => {
  // 프로덕션 환경 (Docker)
  if (window.location.hostname !== 'localhost' && window.location.hostname !== '127.0.0.1') {
    // 같은 도메인에서 실행되는 경우 상대 경로 사용
    return `${window.location.protocol}//${window.location.hostname}:8000`;
  }
  // 개발 환경
  return import.meta.env.VITE_API_BASE_URL || "http://localhost:8000";
};

export const API_BASE_URL = getApiBaseUrl();

export async function getConfig() {
  const res = await fetch(`${API_BASE_URL}/config`);
  return await res.json();
}
