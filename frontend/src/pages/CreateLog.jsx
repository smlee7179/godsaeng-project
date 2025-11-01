import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import api from '../utils/api'
import './CreateLog.css'

const CreateLog = () => {
  const [activity, setActivity] = useState('')
  const [photoUrl, setPhotoUrl] = useState('')
  const [mood, setMood] = useState('')
  const [tags, setTags] = useState('')
  const [location, setLocation] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const navigate = useNavigate()

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    try {
      const tagsArray = tags
        ? tags.split(',').map((tag) => tag.trim()).filter((tag) => tag)
        : []

      await api.post('/api/logs', {
        activity,
        photo_url: photoUrl || null,
        mood: mood || null,
        tags: tagsArray,
        location: location || null,
      })

      navigate('/logs')
    } catch (error) {
      setError(error.response?.data?.detail || '기록 작성에 실패했습니다.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="create-log">
      <h2>새 기록 작성</h2>
      
      <form onSubmit={handleSubmit} className="log-form">
        <div className="form-group">
          <label className="label">활동 내용 *</label>
          <textarea
            className="textarea"
            value={activity}
            onChange={(e) => setActivity(e.target.value)}
            required
            placeholder="오늘 무엇을 하셨나요?"
            rows={5}
          />
        </div>

        <div className="form-group">
          <label className="label">사진 URL (선택사항)</label>
          <input
            type="url"
            className="input"
            value={photoUrl}
            onChange={(e) => setPhotoUrl(e.target.value)}
            placeholder="https://example.com/photo.jpg"
          />
        </div>

        <div className="form-group">
          <label className="label">감정 상태 (선택사항)</label>
          <select
            className="input"
            value={mood}
            onChange={(e) => setMood(e.target.value)}
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
          <label className="label">태그 (선택사항)</label>
          <input
            type="text"
            className="input"
            value={tags}
            onChange={(e) => setTags(e.target.value)}
            placeholder="쉼표로 구분하여 입력하세요 (예: 운동, 독서, 친구만남)"
          />
          <small className="form-help">쉼표로 구분하여 여러 태그를 추가할 수 있습니다.</small>
        </div>

        <div className="form-group">
          <label className="label">위치 (선택사항)</label>
          <input
            type="text"
            className="input"
            value={location}
            onChange={(e) => setLocation(e.target.value)}
            placeholder="장소를 입력하세요"
          />
        </div>

        {error && <div className="error">{error}</div>}

        <div className="form-actions">
          <button
            type="button"
            className="button button-secondary"
            onClick={() => navigate('/logs')}
            disabled={loading}
          >
            취소
          </button>
          <button
            type="submit"
            className="button button-primary"
            disabled={loading}
          >
            {loading ? '저장 중...' : '저장'}
          </button>
        </div>
      </form>
    </div>
  )
}

export default CreateLog

