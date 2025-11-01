import React from 'react'
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import { AuthProvider } from './contexts/AuthContext'
import PrivateRoute from './components/PrivateRoute'
import Login from './pages/Login'
import Register from './pages/Register'
import Dashboard from './pages/Dashboard'
import Logs from './pages/Logs'
import LogDetail from './pages/LogDetail'
import CreateLog from './pages/CreateLog'
import AIReports from './pages/AIReports'
import Layout from './components/Layout'
import './App.css'

function App() {
  return (
    <AuthProvider>
      <Router>
        <Routes>
          <Route path="/login" element={<Login />} />
          <Route path="/register" element={<Register />} />
          <Route
            path="/"
            element={
              <PrivateRoute>
                <Layout>
                  <Dashboard />
                </Layout>
              </PrivateRoute>
            }
          />
          <Route
            path="/logs"
            element={
              <PrivateRoute>
                <Layout>
                  <Logs />
                </Layout>
              </PrivateRoute>
            }
          />
          <Route
            path="/logs/create"
            element={
              <PrivateRoute>
                <Layout>
                  <CreateLog />
                </Layout>
              </PrivateRoute>
            }
          />
          <Route
            path="/logs/:id"
            element={
              <PrivateRoute>
                <Layout>
                  <LogDetail />
                </Layout>
              </PrivateRoute>
            }
          />
          <Route
            path="/ai-reports"
            element={
              <PrivateRoute>
                <Layout>
                  <AIReports />
                </Layout>
              </PrivateRoute>
            }
          />
        </Routes>
      </Router>
    </AuthProvider>
  )
}

export default App

