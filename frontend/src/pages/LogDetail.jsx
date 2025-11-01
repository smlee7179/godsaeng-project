import React, { useState, useEffect } from 'react'
import { useParams, useNavigate, Link } from 'react-router-dom'
import { format } from 'date-fns'
import api from '../utils/api'
import './LogDetail.css'

const LogDetail = () => {
  const { id } = useParams()
  const navigate = useNavigate()
  const [log, setLog] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [editMode, setEditMode] = useState(false)
  const [formData, setFormData] = useState({
    activity: '',
    photo_url: '',
    mood: '',
    tags: '',
    location: '',
  })

  useEffect(() => {
    fetchLog()
  }, [id])

  const fetchLog = async () => {
    try {
      const response = await api.get(`/api/logs/${id}`)
      const logData = response.data
      setLog(logData)
      setFormData({
        activity: logData.activity || '',
        photo_url: logData.photo_url || '',
        mood: logData.mood || '',
        tags: (logData.tags || []).join(', '),
        location: logData.location || '',
      })
    } catch (error) {
      setError('기록을 불러오는데 실패했습니다.')
      console.error(error)
    } finally {
      setLoading(false)
    }
  }

  const handleUpdate = async (e) => {
    e.preventDefault()
    try {
      const tagsArray = formData.tags
        ? formData.tags.split(',').map((tag) => tag.trim()).filter((tag) => tag)
        : []

      await api.put(`/api/logs/${id}`, {
        activity: formData.activity,
        photo_url: formData.photo_url || null,
        mood: formData.mood || null,
        tags: tagsArray,
        location: formData.location || null,
      })

      setEditMode(false)
      fetchLog()
    } catch (error) {
      alert('기록 수정에 실패했습니다.')
      console.error(error)
    }
  }

  const handleDelete = async () => {
    if (!window.confirm('정말 이 기록을 삭제하시겠습니까?')) {
      return
    }

    try {
      await api.delete(`/api/logs/${id}`)
      navigate('/logs')
    } catch (error) {
      alert('기록 삭제에 실패했습니다.')
      console.error(error)
    }
  }

  if (loading) {
    return <div>로딩 중...</div>
  }

  if (error || !log) {
    return (
      <div>
        <div className="error">{error || '기록을 찾을 수 없습니다.'}</div>
        <Link to="/logs" className="button button-primary">
          목록으로 돌아가기
        </Link>
      </div>
    )
  }

  return (
    <div className="log-detail">
      <div className="detail-header">
        <Link to="/logs" className="back-link">← 목록으로</Link>
        <div className="detail-actions">
          <button
            onClick={() => setEditMode(!editMode)}
            className="button button-secondary"
          >
            {editMode ? '취소' : '수정'}
          </button>
          <button
            onClick={handleDelete}
            className="button button-danger"
          >
            삭제
          </button>
        </div>
      </div>

      {editMode ? (
        <form onSubmit={handleUpdate} className="log-form">
          <div className="form-group">
            <label className="label">활동 내용 *</label>
            <textarea
              className="textarea"
              value={formData.activity}
              onChange={(e) => setFormData({ ...formData, activity: e.target.value })}
              required
              rows={5}
            />
          </div>

          <div className="form-group">
            <label className="label">사진 URL</label>
            <input
              type="url"
              className="input"
              value={formData.photo_url}
              onChange={(e) => setFormData({ ...formData, photo_url: e.target.value })}
            />
          </div>

          <div className="form-group">
            <label className="label">감정 상태</label>
            <select
              className="input"
              value={formData.mood}
              onChange={(e) => setFormData({ ...formData, mood: e.target.value })}
            >
              <option value="">선택하세요</option>
              <option value="기쁨">기쁨</option>
              <option value="평온">평온</option>
              <option value="설렘">설렘</option>
              <option value="피로">피로</option>
              <option value="불안">불안</option>
              <option value="슬픔">슬픔</option>
              <option value="분노">분노</option>
            </select>
          </div>

          <div className="form-group">
            <label className="label">태그</label>
            <input
              type="text"
              className="input"
              value={formData.tags}
              onChange={(e) => setFormData({ ...formData, tags: e.target.value })}
              placeholder="쉼표로 구분"
            />
          </div>

          <div className="form-group">
            <label className="label">위치</label>
            <input
              type="text"
              className="input"
              value={formData.location}
              onChange={(e) => setFormData({ ...formData, location: e.target.value })}
            />
          </div>

          <div className="form-actions">
            <button type="submit" className="button button-primary">
              저장
            </button>
          </div>
        </form>
      ) : (
        <div className="detail-card">
          {log.photo_url && (
            <div className="detail-photo">
              <img src={log.photo_url} alt="기록 사진" />
            </div>
          )}

          <div className="detail-content">
            <div className="detail-meta">
              <span>
                {log.timestamp
                  ? format(new Date(log.timestamp), 'yyyy년 MM월 dd일 HH:mm')
                  : '날짜 없음'}
              </span>
              {log.mood && <span className="mood-badge">감정: {log.mood}</span>}
              {log.location && <span>위치: {log.location}</span>}
            </div>

            <h2>{log.activity}</h2>

            {log.tags && log.tags.length > 0 && (
              <div className="detail-tags">
                {log.tags.map((tag, idx) => (
                  <span key={idx} className="tag">
                    #{tag}
                  </span>
                ))}
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  )
}

export default LogDetail

