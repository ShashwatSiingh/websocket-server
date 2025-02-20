const express = require('express');
const dotenv = require('dotenv');
const bodyParser = require('body-parser');

// Load environment variables
dotenv.config();

const app = express();
const port = process.env.PORT || 10000;
const VERSION = '1.0.2';

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Request logging
app.use((req, res, next) => {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`);
    next();
});

// Define all routes
const routes = {
    // Test routes
    'GET /': (req, res) => res.send('Server is running'),
    'GET /ping': (req, res) => res.send('pong'),
    'GET /health': (req, res) => res.json({
        status: 'healthy',
        version: VERSION,
        timestamp: new Date().toISOString()
    }),
    'GET /test-exoml': (req, res) => {
        const response = `<?xml version="1.0" encoding="UTF-8"?>
            <Response>
                <Say>Test response from version ${VERSION}</Say>
            </Response>`;
        res.type('application/xml').send(response);
    },
    'POST /exotel/incoming': (req, res) => {
        console.log('Call received:', req.body);
        const response = `<?xml version="1.0" encoding="UTF-8"?>
            <Response>
                <Say>Connecting your call</Say>
                <Dial>${process.env.FORWARD_TO_NUMBER}</Dial>
            </Response>`;
        res.type('application/xml').send(response);
    }
};

// Register all routes
Object.entries(routes).forEach(([route, handler]) => {
    const [method, path] = route.split(' ');
    app[method.toLowerCase()](path, handler);
});

// Error handler
app.use((err, req, res, next) => {
    const errorResponse = {
        error: 'Server error',
        message: err.message,
        path: req.path,
        method: req.method,
        version: VERSION
    };
    console.error('Error:', errorResponse);
    res.status(500).json(errorResponse);
});

// 404 handler
app.use((req, res) => {
    const notFoundResponse = {
        error: 'Not found',
        path: req.path,
        method: req.method,
        version: VERSION,
        availableRoutes: Object.keys(routes)
    };
    res.status(404).json(notFoundResponse);
});

// Start server
app.listen(port, '0.0.0.0', () => {
    console.log(`Server v${VERSION} running on port ${port}`);
    console.log('Routes registered:', Object.keys(routes));
    console.log('Environment:', {
        NODE_ENV: process.env.NODE_ENV,
        PORT: port,
        hasForwardNumber: !!process.env.FORWARD_TO_NUMBER
    });
});
