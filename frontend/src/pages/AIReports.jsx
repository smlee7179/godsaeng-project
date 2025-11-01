import React, { useState } from 'react'
import { format } from 'date-fns'
import api from '../utils/api'
import './AIReports.css'

const AIReports = () => {
  const [targetDate, setTargetDate] = useState(
    format(new Date(), 'yyyy-MM-dd')
  )
  const [report, setReport] = useState(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [analyzing, setAnalyzing] = useState(false)

  const handleAnalyze = async () => {
    if (!targetDate) {
      setError('날짜를 선택해주세요.')
      return
    }

    setAnalyzing(true)
    setError('')
    setReport(null)

    try {
      const response = await api.post('/api/ai/analyze', {
        date: targetDate,
      })
      setReport(response.data)
    } catch (error) {
      setError(
        error.response?.data?.detail ||
          'AI 분석에 실패했습니다. OpenAI API 키가 설정되어 있는지 확인해주세요.'
      )
      console.error(error)
    } finally {
      setAnalyzing(false)
    }
  }

  const handleGetReport = async () => {
    if (!targetDate) {
      setError('날짜를 선택해주세요.')
      return
    }

    setLoading(true)
    setError('')
    setReport(null)

    try {
      const response = await api.get(
        `/api/ai/report?target_date=${targetDate}`
      )
      setReport(response.data)
    } catch (error) {
      if (error.response?.status === 404) {
        setError('해당 날짜의 리포트가 없습니다. 먼저 분석을 실행해주세요.')
      } else {
        setError('리포트를 불러오는데 실패했습니다.')
      }
      console.error(error)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="ai-reports">
      <h2>AI 일상 분석</h2>

      <div className="report-controls">
        <div className="form-group">
          <label className="label">분석할 날짜 선택</label>
          <input
            type="date"
            className="input"
            value={targetDate}
            onChange={(e) => setTargetDate(e.target.value)}
            max={format(new Date(), 'yyyy-MM-dd')}
          />
        </div>
        <div className="control-buttons">
          <button
            onClick={handleAnalyze}
            className="button button-primary"
            disabled={analyzing || loading}
          >
            {analyzing ? '분석 중...' : '새로 분석하기'}
          </button>
          <button
            onClick={handleGetReport}
            className="button button-secondary"
            disabled={analyzing || loading}
          >
            {loading ? '로딩 중...' : '저장된 리포트 보기'}
          </button>
        </div>
      </div>

      {error && <div className="error">{error}</div>}

      {report && (
        <div className="report-card">
          <div className="report-header">
            <h3>
              {format(new Date(targetDate), 'yyyy년 MM월 dd일')}{' '}
              일상 분석
            </h3>
            {report.created_at && (
              <span className="report-date">
                생성일:{' '}
                {format(new Date(report.created_at), 'yyyy-MM-dd HH:mm')}
              </span>
            )}
          </div>

          <div className="report-section">
            <h4>하루 요약</h4>
            <p className="report-summary">{report.summary}</p>
          </div>

          {report.feedback && (
            <div className="report-section">
              <h4>AI 피드백</h4>
              <p>{report.feedback}</p>
            </div>
          )}

          {report.emotions && report.emotions.length > 0 && (
            <div className="report-section">
              <h4>감정 분석</h4>
              <div className="emotions-list">
                {report.emotions.map((emotion, idx) => (
                  <span key={idx} className="emotion-tag">
                    {emotion}
                  </span>
                ))}
              </div>
            </div>
          )}

          {report.insights && report.insights.length > 0 && (
            <div className="report-section">
              <h4>인사이트</h4>
              <ul className="insights-list">
                {report.insights.map((insight, idx) => (
                  <li key={idx}>{insight}</li>
                ))}
              </ul>
            </div>
          )}

          {report.recommendations && report.recommendations.length > 0 && (
            <div className="report-section">
              <h4>추천사항</h4>
              <ul className="recommendations-list">
                {report.recommendations.map((rec, idx) => (
                  <li key={idx}>{rec}</li>
                ))}
              </ul>
            </div>
          )}
        </div>
      )}

      {!report && !error && !analyzing && !loading && (
        <div className="empty-report">
          <p>날짜를 선택하고 분석을 실행하면 AI가 당신의 일상을 분석해드립니다.</p>
          <p className="help-text">
            💡 OpenAI API 키가 설정되어 있어야 AI 분석 기능을 사용할 수
            있습니다.
          </p>
        </div>
      )}
    </div>
  )
}

export default AIReports

