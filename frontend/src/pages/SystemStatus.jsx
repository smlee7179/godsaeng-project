import React, { useState, useEffect } from 'react'
import api from '../utils/api'
import './SystemStatus.css'

const SystemStatus = () => {
  const [status, setStatus] = useState(null)
  const [health, setHealth] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    fetchSystemStatus()
  }, [])

  const fetchSystemStatus = async () => {
    try {
      setLoading(true)
      setError('')
      
      // 헬스체크
      try {
        const healthResponse = await api.get('/health')
        setHealth(healthResponse.data)
      } catch (err) {
        setHealth({ status: 'error', error: err.message })
      }
      
      // 상세 상태
      try {
        const statusResponse = await api.get('/status')
        setStatus(statusResponse.data)
      } catch (err) {
        setError('상태 정보를 불러올 수 없습니다: ' + err.message)
      }
    } catch (error) {
      setError('시스템 상태를 확인할 수 없습니다.')
      console.error(error)
    } finally {
      setLoading(false)
    }
  }

  const getStatusBadge = (status) => {
    switch (status) {
      case 'healthy':
      case 'connected':
        return <span className="status-badge status-healthy">정상</span>
      case 'degraded':
      case 'not_connected':
        return <span className="status-badge status-warning">경고</span>
      case 'error':
      case 'unhealthy':
        return <span className="status-badge status-error">오류</span>
      default:
        return <span className="status-badge status-unknown">알 수 없음</span>
    }
  }

  const getEnvStatus = (value) => {
    if (value === '설정됨' || value === '설정 안됨') {
      return value === '설정됨' ? (
        <span className="env-status env-set">✓ 설정됨</span>
      ) : (
        <span className="env-status env-not-set">✗ 설정 안됨</span>
      )
    }
    return <span className="env-status env-value">{value}</span>
  }

  if (loading) {
    return (
      <div className="system-status">
        <div className="loading">시스템 상태를 확인하는 중...</div>
      </div>
    )
  }

  return (
    <div className="system-status">
      <div className="status-header">
        <h2>시스템 상태 확인</h2>
        <button onClick={fetchSystemStatus} className="refresh-btn">
          새로고침
        </button>
      </div>

      {error && <div className="error-message">{error}</div>}

      {/* 헬스체크 결과 */}
      {health && (
        <div className="status-card health-card">
          <h3>헬스체크</h3>
          <div className="health-info">
            <div className="health-item">
              <span className="health-label">전체 상태:</span>
              {getStatusBadge(health.status)}
            </div>
            <div className="health-item">
              <span className="health-label">데이터베이스:</span>
              {getStatusBadge(health.database)}
            </div>
            {health.error && (
              <div className="health-error">
                <strong>오류:</strong> {health.error}
              </div>
            )}
          </div>
        </div>
      )}

      {/* 상세 상태 정보 */}
      {status && (
        <>
          <div className="status-card">
            <h3>시스템 상세 상태</h3>
            <div className="status-info">
              <div className="status-item">
                <span className="status-label">전체 상태:</span>
                {getStatusBadge(status.overall_status)}
              </div>
              <div className="status-item">
                <span className="status-label">버전:</span>
                <span className="status-value">{status.version}</span>
              </div>
              {status.timestamp && (
                <div className="status-item">
                  <span className="status-label">확인 시간:</span>
                  <span className="status-value">
                    {new Date(status.timestamp).toLocaleString('ko-KR')}
                  </span>
                </div>
              )}
            </div>
          </div>

          {/* 데이터베이스 상태 */}
          {status.components?.database && (
            <div className="status-card">
              <h3>데이터베이스</h3>
              <div className="component-info">
                <div className="component-item">
                  <span className="component-label">상태:</span>
                  {getStatusBadge(status.components.database.status)}
                </div>
                {status.components.database.name && (
                  <div className="component-item">
                    <span className="component-label">데이터베이스 이름:</span>
                    <span className="component-value">
                      {status.components.database.name}
                    </span>
                  </div>
                )}
                {status.components.database.collections !== undefined && (
                  <div className="component-item">
                    <span className="component-label">컬렉션 수:</span>
                    <span className="component-value">
                      {status.components.database.collections}
                    </span>
                  </div>
                )}
                {status.components.database.error && (
                  <div className="component-error">
                    <strong>오류:</strong> {status.components.database.error}
                  </div>
                )}
              </div>
            </div>
          )}

          {/* 환경 변수 상태 */}
          {status.components?.environment && (
            <div className="status-card">
              <h3>환경 설정</h3>
              <div className="env-list">
                {Object.entries(status.components.environment).map(
                  ([key, value]) => (
                    <div key={key} className="env-item">
                      <span className="env-key">{key}:</span>
                      {getEnvStatus(value)}
                    </div>
                  )
                )}
              </div>
            </div>
          )}
        </>
      )}

      {/* 테스트 안내 */}
      <div className="status-card info-card">
        <h3>테스트 안내</h3>
        <div className="info-content">
          <p>
            <strong>정상 상태:</strong> 모든 컴포넌트가 정상적으로 작동 중입니다.
          </p>
          <p>
            <strong>경고 상태:</strong> 일부 컴포넌트에 문제가 있지만 기본 기능은 작동합니다.
          </p>
          <p>
            <strong>오류 상태:</strong> 중요한 컴포넌트에 오류가 있습니다. 로그를 확인하세요.
          </p>
          <div className="test-links">
            <h4>빠른 테스트 링크:</h4>
            <ul>
              <li>
                <a
                  href="https://godsaeng-backend.onrender.com/docs"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  API 문서 (Swagger)
                </a>
              </li>
              <li>
                <a
                  href="https://godsaeng-backend.onrender.com/health"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  헬스체크 엔드포인트
                </a>
              </li>
              <li>
                <a
                  href="https://godsaeng-frontend.onrender.com"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  프론트엔드 애플리케이션
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  )
}

export default SystemStatus

