// 환경에 따른 API URL 설정
const getApiBaseUrl = () => {
  // 환경 변수가 설정되어 있으면 사용 (Render 배포용)
  if (import.meta.env.VITE_API_BASE_URL) {
    return import.meta.env.VITE_API_BASE_URL;
  }
  
  // 프로덕션 환경 (Docker 또는 외부 호스트)
  if (window.location.hostname !== 'localhost' && window.location.hostname !== '127.0.0.1') {
    // Render 배포 시 백엔드 URL 추론
    if (window.location.hostname.includes('onrender.com')) {
      // 프론트엔드가 Render에 배포된 경우
      const frontendName = window.location.hostname.split('.')[0];
      const backendName = frontendName.replace('frontend', 'backend').replace('-frontend', '-backend');
      return `https://${backendName}.onrender.com`;
    }
    // 다른 환경에서는 같은 호스트의 8000 포트 사용
    return `${window.location.protocol}//${window.location.hostname}:8000`;
  }
  
  // 개발 환경
  return "http://localhost:8000";
};

export const API_BASE_URL = getApiBaseUrl();

export async function getConfig() {
  const res = await fetch(`${API_BASE_URL}/config`);
  return await res.json();
}
