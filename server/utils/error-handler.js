export class WebSocketError extends Error {
    constructor(message, code) {
        super(message);
        this.name = 'WebSocketError';
        this.code = code;
    }
}

export function handleError(error, fastify) {
    if (error instanceof WebSocketError) {
        fastify.log.error(`WebSocket Error (${error.code}): ${error.message}`);
    } else {
        fastify.log.error('Unexpected Error:', error);
    }
}