import React, { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import { format } from 'date-fns'
import api from '../utils/api'
import './Logs.css'

const Logs = () => {
  const [logs, setLogs] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [page, setPage] = useState(0)
  const [hasMore, setHasMore] = useState(true)

  useEffect(() => {
    fetchLogs()
  }, [])

  const fetchLogs = async () => {
    try {
      setLoading(true)
      const response = await api.get(`/api/logs?skip=${page * 20}&limit=20`)
      setLogs(response.data)
      setHasMore(response.data.length === 20)
    } catch (error) {
      setError('기록을 불러오는데 실패했습니다.')
      console.error(error)
    } finally {
      setLoading(false)
    }
  }

  const handleDelete = async (logId, e) => {
    e.stopPropagation()
    if (!window.confirm('정말 이 기록을 삭제하시겠습니까?')) {
      return
    }

    try {
      await api.delete(`/api/logs/${logId}`)
      setLogs(logs.filter((log) => log.id !== logId))
    } catch (error) {
      alert('기록 삭제에 실패했습니다.')
      console.error(error)
    }
  }

  if (loading && logs.length === 0) {
    return <div>로딩 중...</div>
  }

  return (
    <div className="logs-page">
      <div className="page-header">
        <h2>라이프 기록</h2>
        <Link to="/logs/create" className="button button-primary">
          + 새 기록 작성
        </Link>
      </div>

      {error && <div className="error">{error}</div>}

      {logs.length === 0 ? (
        <div className="empty-state">
          <p>아직 기록이 없습니다.</p>
          <Link to="/logs/create" className="button button-primary">
            첫 번째 기록 작성하기
          </Link>
        </div>
      ) : (
        <div className="logs-grid">
          {logs.map((log) => (
            <div key={log.id} className="log-card">
              <Link to={`/logs/${log.id}`} className="log-card-link">
                {log.photo_url && (
                  <div className="log-card-photo">
                    <img src={log.photo_url} alt="기록 사진" />
                  </div>
                )}
                <div className="log-card-content">
                  <h3>{log.activity}</h3>
                  <p className="log-card-meta">
                    {log.timestamp
                      ? format(new Date(log.timestamp), 'yyyy년 MM월 dd일 HH:mm')
                      : '날짜 없음'}
                  </p>
                  {log.mood && (
                    <span className="log-card-mood">감정: {log.mood}</span>
                  )}
                  {log.tags && log.tags.length > 0 && (
                    <div className="log-card-tags">
                      {log.tags.slice(0, 3).map((tag, idx) => (
                        <span key={idx} className="tag">
                          #{tag}
                        </span>
                      ))}
                    </div>
                  )}
                </div>
              </Link>
              <button
                onClick={(e) => handleDelete(log.id, e)}
                className="button button-danger delete-btn"
              >
                삭제
              </button>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

export default Logs

