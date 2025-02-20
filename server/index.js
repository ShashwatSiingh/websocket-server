const express = require('express');
const dotenv = require('dotenv');
const bodyParser = require('body-parser');
const WebSocket = require('ws');

// Load environment variables
dotenv.config();

// Validate required environment variables
const requiredEnvVars = ['FORWARD_TO_NUMBER', 'EXOTEL_CALLER_ID', 'EXOTEL_APP_ID'];
const missingEnvVars = requiredEnvVars.filter(varName => !process.env[varName]);

if (missingEnvVars.length > 0) {
    console.error('Missing required environment variables:', missingEnvVars);
    process.exit(1);
}

const app = express();
const port = process.env.PORT || 10000;
const wsPort = process.env.WS_PORT || 8080;
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
    'GET /health': (req, res) => {
        const config = {
            hasForwardNumber: !!process.env.FORWARD_TO_NUMBER,
            hasCallerId: !!process.env.EXOTEL_CALLER_ID,
            hasAppId: !!process.env.EXOTEL_APP_ID,
            hasServerUrl: !!process.env.SERVER_URL,
            forwardNumber: process.env.FORWARD_TO_NUMBER,
            callerId: process.env.EXOTEL_CALLER_ID,
            appId: process.env.EXOTEL_APP_ID,
            serverUrl: process.env.SERVER_URL
        };

        res.json({
            status: 'healthy',
            version: VERSION,
            timestamp: new Date().toISOString(),
            config
        });
    },
    'GET /test-exoml': (req, res) => {
        const response = `<?xml version="1.0" encoding="UTF-8"?>
            <Response>
                <Say>Test response from version ${VERSION}</Say>
            </Response>`;
        res.type('application/xml').send(response);
    },
    'POST /exotel/incoming': (req, res) => {
        const callerId = process.env.EXOTEL_CALLER_ID;
        const forwardTo = process.env.FORWARD_TO_NUMBER;
        const serverUrl = process.env.SERVER_URL;

        console.log('Call received:', {
            body: req.body,
            env: {
                callerId,
                forwardTo,
                serverUrl
            }
        });

        if (!callerId || !forwardTo || !serverUrl) {
            console.error('Missing required environment variables');
            const errorResponse = `<?xml version="1.0" encoding="UTF-8"?>
                <Response>
                    <Say voice="WOMAN">Sorry, there was a configuration error.</Say>
                    <Hangup/>
                </Response>`;
            return res.type('application/xml').send(errorResponse);
        }

        const response = `<?xml version="1.0" encoding="UTF-8"?>
            <Response>
                <Say voice="WOMAN">Please wait while we connect your call.</Say>
                <Dial callerId="${callerId}"
                      record="true"
                      action="${serverUrl}/exotel/callback">
                    <Number>${forwardTo}</Number>
                </Dial>
                <Say voice="WOMAN">Call ended. Goodbye.</Say>
            </Response>`;

        console.log('Sending response:', response);
        res.type('application/xml').send(response);
    },
    'POST /exotel/callback': (req, res) => {
        console.log('Call status callback received:', {
            body: req.body,
            query: req.query,
            timestamp: new Date().toISOString()
        });
        res.sendStatus(200);
    }
};

// Register all routes
Object.entries(routes).forEach(([route, handler]) => {
    const [method, path] = route.split(' ');
    console.log(`Registering route: ${method} ${path}`);
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

// Start HTTP server
const server = app.listen(port, '0.0.0.0', () => {
    console.log(`HTTP server v${VERSION} running on port ${port}`);
    console.log('Routes registered:', Object.entries(routes).map(([route]) => route));
    console.log('Environment:', {
        NODE_ENV: process.env.NODE_ENV,
        PORT: port,
        WS_PORT: wsPort,
        FORWARD_TO_NUMBER: process.env.FORWARD_TO_NUMBER,
        EXOTEL_CALLER_ID: process.env.EXOTEL_CALLER_ID,
        EXOTEL_APP_ID: process.env.EXOTEL_APP_ID,
        SERVER_URL: process.env.SERVER_URL
    });
});

// Start WebSocket server
const wss = new WebSocket.Server({ port: wsPort });

wss.on('connection', (ws) => {
    console.log('WebSocket client connected');

    ws.on('message', (message) => {
        console.log('Received:', message);
        // Echo back for testing
        ws.send(`Server received: ${message}`);
    });

    ws.on('close', () => {
        console.log('Client disconnected');
    });
});

console.log(`WebSocket server running on port ${wsPort}`);

// Handle graceful shutdown
process.on('SIGTERM', () => {
    console.log('SIGTERM received. Shutting down gracefully...');
    server.close(() => {
        wss.close(() => {
            console.log('Servers closed');
            process.exit(0);
        });
    });
});
