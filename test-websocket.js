import WebSocket from 'ws';

const ws = new WebSocket('wss://ee76-103-81-39-78.ngrok-free.app/exotel-stream');

ws.on('open', () => {
    console.log('Connected to server');

    // Send a test message
    ws.send(JSON.stringify({
        type: 'test',
        message: 'Hello server'
    }));
});

ws.on('message', (data) => {
    console.log('Received:', data.toString());
});

ws.on('close', (code, reason) => {
    console.log(`Disconnected (code: ${code}, reason: ${reason})`);
});

ws.on('error', (error) => {
    console.error('WebSocket error:', error);
});