const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Security middleware
app.use(helmet());
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || ['http://localhost:3000'],
  credentials: true
}));

// Body parsing middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Security headers
app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
  next();
});

// Routes
app.get('/', (req, res) => {
  res.json({
    message: 'Friendly Octo Lamp - Security Demo Application',
    version: '1.0.0',
    security: {
      codeql_enabled: true,
      dependabot_enabled: true,
      workflow_validation: true
    }
  });
});

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// Secure API endpoint with input validation
app.post('/api/data', (req, res) => {
  try {
    // Input validation
    const { data, type } = req.body;
    
    if (!data || typeof data !== 'string') {
      return res.status(400).json({
        error: 'Invalid data parameter'
      });
    }
    
    if (!type || !['text', 'json', 'xml'].includes(type)) {
      return res.status(400).json({
        error: 'Invalid type parameter'
      });
    }
    
    // Secure data processing
    const processedData = {
      original_length: data.length,
      type: type,
      processed_at: new Date().toISOString(),
      safe_content: data.substring(0, 100) // Limit output
    };
    
    res.json({
      success: true,
      data: processedData
    });
  } catch (error) {
    console.error('Processing error:', error.message);
    res.status(500).json({
      error: 'Internal server error'
    });
  }
});

// Security monitoring endpoint
app.get('/security/status', (req, res) => {
  const securityStatus = {
    helmet_enabled: true,
    cors_configured: true,
    input_validation: true,
    rate_limiting: false, // Could be added
    logging: true,
    environment: process.env.NODE_ENV || 'development'
  };
  
  res.json(securityStatus);
});

// Error handling middleware
app.use((error, req, res, next) => {
  console.error('Error:', error.message);
  res.status(500).json({
    error: 'Something went wrong',
    requestId: req.headers['x-request-id'] || 'unknown'
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: 'Not Found',
    path: req.path
  });
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('Received SIGTERM, shutting down gracefully');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('Received SIGINT, shutting down gracefully');
  process.exit(0);
});

if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
    console.log(`🛡️ Security features enabled`);
    console.log(`📊 Environment: ${process.env.NODE_ENV || 'development'}`);
  });
}

module.exports = app;