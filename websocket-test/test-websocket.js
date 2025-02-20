import WebSocket from 'ws';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
import dotenv from 'dotenv';
import path from 'path';

// Setup ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Load environment variables from .env
dotenv.config({ path: path.join(__dirname, '.env') });

const wsUrl = process.env.NGROK_URL;
if (!wsUrl) {
    console.error('NGROK_URL not found in environment variables');
    process.exit(1);
}

console.log('Attempting connection to:', wsUrl + '/exotel-stream');

const wsOptions = {
    headers: {
        'User-Agent': 'WebSocket-Test-Client',
        'Origin': 'http://localhost',
        'Upgrade': 'websocket',
        'Connection': 'Upgrade',
        'Sec-WebSocket-Version': '13',
        'Sec-WebSocket-Key': 'dGhlIHNhbXBsZSBub25jZQ=='
    },
    rejectUnauthorized: false // Only for testing
};

function createWebSocket() {
    console.log('Creating WebSocket with options:', JSON.stringify(wsOptions, null, 2));

    const ws = new WebSocket(wsUrl + '/exotel-stream', wsOptions);

    // Connection opening
    ws.on('connecting', () => {
        console.log('WebSocket is connecting...');
    });

    ws.on('open', () => {
        console.log('Connection established successfully');
        reconnectAttempts = 0;

        // Send a test message
        const testMessage = JSON.stringify({ type: 'test', message: 'Hello server!' });
        console.log('Sending test message:', testMessage);
        ws.send(testMessage);
    });

    ws.on('message', (data) => {
        try {
            const message = JSON.parse(data.toString());
            console.log('Received message:', message);
        } catch (e) {
            console.log('Received raw data:', data.toString());
        }
    });

    ws.on('error', (error) => {
        console.error('WebSocket error details:', {
            message: error.message,
            code: error.code,
            type: error.type,
            target: error.target
        });
    });

    return ws;
}

let reconnectAttempts = 0;
const MAX_RECONNECT_ATTEMPTS = 3;
const RECONNECT_DELAY = 5000;

function handleDisconnect(ws) {
    ws.on('close', (code, reason) => {
        console.log(`Disconnected (code: ${code}, reason: ${reason || 'No reason provided'})`);

        if (reconnectAttempts < MAX_RECONNECT_ATTEMPTS) {
            reconnectAttempts++;
            console.log(`Attempting to reconnect (${reconnectAttempts}/${MAX_RECONNECT_ATTEMPTS})...`);
            setTimeout(() => {
                console.log('Reconnecting...');
                const newWs = createWebSocket();
                handleDisconnect(newWs);
            }, RECONNECT_DELAY);
        } else {
            console.log('Max reconnection attempts reached. Exiting...');
            process.exit(1);
        }
    });
}

// Create initial connection
const ws = createWebSocket();
handleDisconnect(ws);

// Cleanup on process exit
process.on('SIGINT', () => {
    console.log('Closing connection...');
    ws.close();
    process.exit(0);
});