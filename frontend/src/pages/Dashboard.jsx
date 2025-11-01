import React, { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import { format } from 'date-fns'
import api from '../utils/api'
import './Dashboard.css'

const Dashboard = () => {
  const [stats, setStats] = useState({
    todayLogs: 0,
    totalLogs: 0,
    recentLogs: [],
  })
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchDashboardData()
  }, [])

  const fetchDashboardData = async () => {
    try {
      // 오늘의 기록
      const todayResponse = await api.get('/api/logs/today')
      
      // 최근 기록 (10개)
      const recentResponse = await api.get('/api/logs?limit=10')
      
      // 전체 기록 개수
      const allLogsResponse = await api.get('/api/logs?limit=1000')
      
      setStats({
        todayLogs: todayResponse.data.length,
        totalLogs: allLogsResponse.data.length,
        recentLogs: recentResponse.data,
      })
    } catch (error) {
      console.error('대시보드 데이터 로드 실패:', error)
    } finally {
      setLoading(false)
    }
  }

  if (loading) {
    return <div>로딩 중...</div>
  }

  return (
    <div className="dashboard">
      <h2>대시보드</h2>
      
      <div className="stats-grid">
        <div className="stat-card">
          <h3>오늘의 기록</h3>
          <p className="stat-number">{stats.todayLogs}</p>
        </div>
        <div className="stat-card">
          <h3>전체 기록</h3>
          <p className="stat-number">{stats.totalLogs}</p>
        </div>
        <div className="stat-card">
          <Link to="/logs/create" className="stat-card-link">
            <h3>새 기록 작성</h3>
            <p className="stat-link">+ 기록 추가하기</p>
          </Link>
        </div>
      </div>

      <div className="recent-logs">
        <div className="section-header">
          <h3>최근 기록</h3>
          <Link to="/logs" className="view-all">전체 보기 →</Link>
        </div>
        
        {stats.recentLogs.length === 0 ? (
          <div className="empty-state">
            <p>아직 기록이 없습니다.</p>
            <Link to="/logs/create" className="button button-primary">
              첫 번째 기록 작성하기
            </Link>
          </div>
        ) : (
          <div className="logs-list">
            {stats.recentLogs.map((log) => (
              <Link
                key={log.id}
                to={`/logs/${log.id}`}
                className="log-item"
              >
                <div className="log-content">
                  <h4>{log.activity}</h4>
                  <p className="log-meta">
                    {log.timestamp
                      ? format(new Date(log.timestamp), 'yyyy년 MM월 dd일 HH:mm')
                      : '날짜 없음'}
                    {log.mood && ` • ${log.mood}`}
                  </p>
                  {log.tags && log.tags.length > 0 && (
                    <div className="tags">
                      {log.tags.map((tag, idx) => (
                        <span key={idx} className="tag">
                          #{tag}
                        </span>
                      ))}
                    </div>
                  )}
                </div>
                {log.photo_url && (
                  <div className="log-photo">
                    <img src={log.photo_url} alt="기록 사진" />
                  </div>
                )}
              </Link>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}

export default Dashboard

