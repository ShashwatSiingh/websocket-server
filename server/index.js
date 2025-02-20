import Fastify from 'fastify';
import fastifyWs from '@fastify/websocket';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

const PORT = process.env.PORT || 5050;

const start = async () => {
    try {
        const fastify = Fastify({
            logger: true
        });

        // Register WebSocket plugin
        await fastify.register(fastifyWs);

        // Basic health check route
        fastify.get('/', (request, reply) => {
            fastify.log.info('Health check requested');
            return { status: 'Server is running' };
        });

        // WebSocket route
        fastify.get('/exotel-stream', { websocket: true }, (connection, req) => {
            fastify.log.info('WebSocket connection attempt', {
                userAgent: req.headers['user-agent'],
                headers: req.headers
            });

            connection.socket.on('message', message => {
                fastify.log.info('Received message:', message.toString());
                // Echo the message back
                connection.socket.send(message.toString());
            });

            connection.socket.on('close', () => {
                fastify.log.info('Client disconnected');
            });

            connection.socket.on('error', (error) => {
                fastify.log.error('WebSocket error:', error);
            });

            // Send a welcome message
            try {
                const welcomeMessage = JSON.stringify({
                    type: 'welcome',
                    message: 'Connected to WebSocket server'
                });
                fastify.log.info('Sending welcome message:', welcomeMessage);
                connection.socket.send(welcomeMessage);
            } catch (error) {
                fastify.log.error('Error sending welcome message:', error);
            }
        });

        // Add error handler
        fastify.setErrorHandler((error, request, reply) => {
            fastify.log.error('Server error:', error);
            reply.status(500).send({ error: 'Internal Server Error' });
        });

        // Start the server
        await fastify.listen({
            port: PORT,
            host: '0.0.0.0'
        });

        fastify.log.info(`Server running at http://localhost:${PORT}`);
        fastify.log.info(`WebSocket endpoint available at ws://localhost:${PORT}/exotel-stream`);
        fastify.log.info('Registered routes:', fastify.printRoutes());

    } catch (err) {
        console.error('Error starting server:', err);
        process.exit(1);
    }
};

// Start the server
start();
