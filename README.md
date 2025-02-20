# WebSocket Server

A WebSocket server implementation for handling real-time communication.

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
