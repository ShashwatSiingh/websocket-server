const express = require('express');
const WebSocket = require('ws');
const dotenv = require('dotenv');
const bodyParser = require('body-parser');
const { handleIncomingCall, handleExotelWebhook } = require('./services/call_handler_service');

// Load environment variables
dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Create WebSocket server
const wss = new WebSocket.Server({ port: process.env.WS_PORT || 8080 });

// Store connected clients
const clients = new Map();

// WebSocket connection handling
wss.on('connection', (ws) => {
  console.log('New client connected');

  // Store client connection
  const clientId = Date.now();
  clients.set(clientId, ws);

  // Send initial connection message
  ws.send(JSON.stringify({ type: 'connection', status: 'connected' }));

  // Handle client disconnection
  ws.on('close', () => {
    console.log('Client disconnected');
    clients.delete(clientId);
  });

  // Handle errors
  ws.on('error', (error) => {
    console.error('WebSocket error:', error);
  });
});

// Exotel webhook endpoint
app.post('/exotel/webhook', async (req, res) => {
  try {
    const webhookData = req.body;
    console.log('Received Exotel webhook:', webhookData);

    // Handle webhook and broadcast to relevant clients
    await handleExotelWebhook(webhookData, clients);

    res.status(200).json({ status: 'success' });
  } catch (error) {
    console.error('Error handling Exotel webhook:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    service: process.env.SERVICE_NAME || 'primary',
    timestamp: new Date().toISOString()
  });
});

// Start Express server
app.listen(port, () => {
  console.log(`Express server running on port ${port}`);
  console.log(`WebSocket server running on port ${process.env.WS_PORT || 8080}`);
});
