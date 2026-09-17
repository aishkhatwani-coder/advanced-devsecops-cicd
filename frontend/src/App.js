import React, { useEffect, useState } from 'react';

function App() {
  const [status, setStatus] = useState({ state: 'Loading...', env: 'Checking...', db: 'Checking...' });

  useEffect(() => {
    fetch('/api/health')
      .then(res => res.json())
      .then(data => setStatus({ state: data.status, env: 'Blue (Active)', db: data.database }))
      .catch(() => setStatus({ state: 'Degraded', env: 'Blue (Active)', db: 'Disconnected' }));
  }, []);

  return (
    <div style={{ fontFamily: 'Segoe UI, sans-serif', padding: '40px', textAlign: 'center', background: '#f4f6f8', minHeight: '100vh' }}>
      <div style={{ background: 'white', maxWidth: '650px', margin: '0 auto', padding: '30px', borderRadius: '12px', boxShadow: '0 4px 12px rgba(0,0,0,0.1)' }}>
        <h1 style={{ color: '#1a365d', marginBottom: '10px' }}>DevSecOps Production Portal</h1>
        <p style={{ color: '#718096', marginBottom: '30px' }}>Zero-Downtime Blue/Green Deployment System</p>
        
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '15px', marginBottom: '30px' }}>
          <div style={{ padding: '15px', borderRadius: '8px', background: '#ebf8ff' }}>
            <span style={{ fontSize: '12px', color: '#2b6cb0', fontWeight: 'bold' }}>SYSTEM STATUS</span>
            <h3 style={{ margin: '8px 0 0 0', color: '#2c5282' }}>{status.state}</h3>
          </div>
          <div style={{ padding: '15px', borderRadius: '8px', background: '#e6fffa' }}>
            <span style={{ fontSize: '12px', color: '#234e52', fontWeight: 'bold' }}>ENVIRONMENT</span>
            <h3 style={{ margin: '8px 0 0 0', color: '#0070f3' }}>{status.env}</h3>
          </div>
          <div style={{ padding: '15px', borderRadius: '8px', background: '#f0fff4' }}>
            <span style={{ fontSize: '12px', color: '#22543d', fontWeight: 'bold' }}>DATABASE</span>
            <h3 style={{ margin: '8px 0 0 0', color: '#38a169' }}>{status.db}</h3>
          </div>
        </div>

        <div style={{ textAlign: 'left', background: '#edf2f7', padding: '15px', borderRadius: '8px', fontSize: '14px' }}>
          <strong>Architecture Highlights:</strong>
          <ul style={{ margin: '8px 0 0 15px', color: '#4a5568' }}>
            <li>Nginx Reverse Proxy on Port 80</li>
            <li>PostgreSQL Migration with Automated Pre-Deploy Backup</li>
            <li>Gitleaks & Semgrep Automated Quality Gates</li>
          </ul>
        </div>
      </div>
    </div>
  );
}

export default App;
