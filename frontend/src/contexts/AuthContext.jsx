import React, { createContext, useContext, useState, useEffect } from 'react'
import api from '../utils/api'

const AuthContext = createContext(null)

export const useAuth = () => {
  const context = useContext(AuthContext)
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider')
  }
  return context
}

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // 로컬 스토리지에서 사용자 정보 복원
    const savedUser = localStorage.getItem('user')
    const token = localStorage.getItem('access_token')
    
    if (savedUser && token) {
      try {
        setUser(JSON.parse(savedUser))
        // 토큰 유효성 확인
        checkAuth()
      } catch (error) {
        console.error('사용자 정보 복원 실패:', error)
        localStorage.removeItem('user')
        localStorage.removeItem('access_token')
      }
    }
    setLoading(false)
  }, [])

  const checkAuth = async () => {
    try {
      const response = await api.get('/api/auth/me')
      setUser(response.data)
      localStorage.setItem('user', JSON.stringify(response.data))
    } catch (error) {
      // 토큰이 유효하지 않으면 로그아웃
      logout()
    }
  }

  const login = async (email, password) => {
    try {
      const response = await api.post('/api/auth/login-json', {
        email,
        password,
      })
      
      const { access_token, user: userData } = response.data
      
      localStorage.setItem('access_token', access_token)
      localStorage.setItem('user', JSON.stringify(userData))
      setUser(userData)
      
      return { success: true }
    } catch (error) {
      return {
        success: false,
        error: error.response?.data?.detail || '로그인에 실패했습니다.',
      }
    }
  }

  const register = async (name, email, password) => {
    try {
      const response = await api.post('/api/auth/register', {
        name,
        email,
        password,
      })
      
      // 회원가입 후 자동 로그인
      return await login(email, password)
    } catch (error) {
      return {
        success: false,
        error: error.response?.data?.detail || '회원가입에 실패했습니다.',
      }
    }
  }

  const logout = () => {
    localStorage.removeItem('access_token')
    localStorage.removeItem('user')
    setUser(null)
  }

  const value = {
    user,
    loading,
    login,
    register,
    logout,
    isAuthenticated: !!user,
  }

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}

