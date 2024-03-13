import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';

export default function AppRouter() {
  return (
    <div>
      <Router>
        <Routes>
            <Route exact path="/" element={<Login/>} />
            <Route exact path="/dashboard" element={<Dashboard/>}/>
        </Routes>
      </Router>
    </div>
  );
};