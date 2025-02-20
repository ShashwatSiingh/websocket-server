# WebSocket Server for Call Handling

A WebSocket server implementation for handling real-time call notifications and management.

## Features

- Real-time WebSocket communication
- Call notification handling
- Support for voice and video calls
- Health check endpoint
- Environment-based configuration

## Project Structure

Essential files in repository:
```
.
├── lib/                    # Flutter client code
│   ├── main.dart
│   └── services/
│       └── call_handler_service.dart
├── server/                 # WebSocket server
│   ├── index.js           # Main server entry point
│   ├── services/          # Server services
│   │   ├── call_handler_service.js
│   │   └── health_check.js
│   ├── package.json       # Server dependencies
│   └── .env.example       # Environment template
├── .gitignore
├── README.md
└── render.yaml            # Deployment configuration
```

Note: Platform-specific files (Android, iOS, etc.) are generated during build.

## Server Setup

1. Install dependencies:
```bash
cd server
npm install
```

2. Create a `.env` file in the server directory:
```env
PORT=5050
OPENAI_API_KEY=your_openai_key
```

3. Start the server:
```bash
npm start
```

## Test Client Setup

1. Install test client dependencies:
```bash
cd websocket-test
npm install
```

2. Create a `.env` file in websocket-test directory:
```env
NGROK_URL=wss://your-render-url.onrender.com
```

3. Run the test client:
```bash
npm start
```

## Development

- Server runs on port 5050 by default
- WebSocket endpoint: `/exotel-stream`
- Supports automatic reconnection
- Includes error handling and logging

## Exotel Integration

### Setup

1. Get your Exotel credentials:
   - SID
   - Token
   - Subdomain
   - Caller ID

2. Configure webhook URL in Exotel dashboard:
   - Add webhook URL: `https://your-server-url.com/exotel/webhook`
   - Select events to receive

### API Flow

1. Client initiates call via WebSocket:
```javascript
{
  "type": "incoming_call",
  "callerId": "1234567890",
  "recipientId": "9876543210",
  "callType": "voice"
}
```

2. Server initiates call via Exotel API

3. Exotel sends webhook events to `/exotel/webhook`

4. Server broadcasts call status to all connected clients:
```javascript
{
  "type": "call_status_update",
  "data": {
    "callSid": "xxxx",
    "status": "initiated|ringing|in-progress|completed",
    "from": "1234567890",
    "to": "9876543210",
    "timestamp": "2024-03-14T12:00:00Z"
  }
}
```

## Deployment

The application is deployed with redundancy using two Render instances:

- Primary URL: `https://websocket-server-primary.onrender.com`
- Fallback URL: `https://websocket-server-fallback.onrender.com`

### Exotel Configuration

Configure your Exotel webhook URLs:

1. Primary Webhook: `https://websocket-server-primary.onrender.com/exotel/webhook`
2. Fallback Webhook: `https://websocket-server-fallback.onrender.com/exotel/webhook`

The system will automatically failover to the fallback server if the primary becomes unavailable.
