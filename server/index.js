const express = require('express');
const WebSocket = require('ws');
const dotenv = require('dotenv');
const { handleIncomingCall } = require('./services/call_handler_service');

// Load environment variables
dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

// Create WebSocket server
const wss = new WebSocket.Server({ port: process.env.WS_PORT || 8080 });

// WebSocket connection handling
wss.on('connection', (ws) => {
  console.log('New client connected');

  // Send initial connection message
  ws.send(JSON.stringify({ type: 'connection', status: 'connected' }));

  // Handle incoming messages
  ws.on('message', async (message) => {
    try {
      const data = JSON.parse(message);

      switch (data.type) {
        case 'incoming_call':
          await handleIncomingCall(data, ws);
          break;

        // Add other message type handlers here

        default:
          ws.send(JSON.stringify({
            type: 'error',
            message: 'Unknown message type'
          }));
      }
    } catch (error) {
      console.error('Error processing message:', error);
      ws.send(JSON.stringify({
        type: 'error',
        message: 'Error processing message'
      }));
    }
  });

  // Handle client disconnection
  ws.on('close', () => {
    console.log('Client disconnected');
  });

  // Handle errors
  ws.on('error', (error) => {
    console.error('WebSocket error:', error);
  });
});

// Express routes
app.get('/health', (req, res) => {
  res.json({ status: 'healthy' });
});

// Start Express server
app.listen(port, () => {
  console.log(`Express server running on port ${port}`);
  console.log(`WebSocket server running on port ${process.env.WS_PORT || 8080}`);
});
