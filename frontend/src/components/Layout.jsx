import React from 'react'
import { Link, useLocation } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import './Layout.css'

const Layout = ({ children }) => {
  const { user, logout } = useAuth()
  const location = useLocation()

  const handleLogout = () => {
    logout()
    window.location.href = '/login'
  }

  return (
    <div className="layout">
      <header className="header">
        <div className="container">
          <div className="header-content">
            <Link to="/" className="logo">
              <h1>GODSAENG</h1>
            </Link>
            <nav className="nav">
              <Link
                to="/"
                className={location.pathname === '/' ? 'nav-link active' : 'nav-link'}
              >
                대시보드
              </Link>
              <Link
                to="/logs"
                className={location.pathname.startsWith('/logs') ? 'nav-link active' : 'nav-link'}
              >
                기록
              </Link>
              <Link
                to="/ai-reports"
                className={location.pathname.startsWith('/ai-reports') ? 'nav-link active' : 'nav-link'}
              >
                AI 분석
              </Link>
            </nav>
            <div className="user-menu">
              <span className="user-name">{user?.name}</span>
              <button onClick={handleLogout} className="button button-secondary">
                로그아웃
              </button>
            </div>
          </div>
        </div>
      </header>
      <main className="main">
        <div className="container">
          {children}
        </div>
      </main>
    </div>
  )
}

export default Layout

