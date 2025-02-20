const axios = require('axios');
const WebSocket = require('ws');
require('dotenv').config();  // Add this line to load environment variables

class ExotelService {
    constructor() {
        // Use environment variables
        this.sid = process.env.EXOTEL_SID;
        this.token = process.env.EXOTEL_TOKEN;
        this.apiKey = process.env.EXOTEL_API_KEY;
        this.callerId = process.env.EXOTEL_CALLER_ID;
        this.subdomain = process.env.EXOTEL_SUBDOMAIN || 'api.exotel.com';
        this.region = process.env.EXOTEL_REGION || 'sg';

        // Debug log to check values
        console.log('Environment variables:', {
            sid: process.env.EXOTEL_SID,
            token: process.env.EXOTEL_TOKEN ? '***' : undefined,
            apiKey: process.env.EXOTEL_API_KEY ? '***' : undefined,
            callerId: process.env.EXOTEL_CALLER_ID,
            subdomain: process.env.EXOTEL_SUBDOMAIN,
            region: process.env.EXOTEL_REGION
        });

        // Construct base URL for Singapore region
        this.baseUrl = `https://${this.subdomain}/v1/Accounts/${this.sid}`;

        // Validate required credentials
        if (!this.sid || !this.token || !this.apiKey || !this.callerId) {
            throw new Error('Missing required Exotel credentials. Please check your .env file');
        }

        console.log('Exotel Service initialized with:', {
            sid: this.sid,
            subdomain: this.subdomain,
            region: this.region,
            baseUrl: this.baseUrl
        });
    }

    async initiateCall(from, to) {
        try {
            const auth = {
                username: this.apiKey,
                password: this.token
            };

            // Format phone numbers (remove '+' and any other non-digits)
            from = from.replace(/\D/g, '');
            to = to.replace(/\D/g, '');

            const formData = new URLSearchParams();
            formData.append('From', from);
            formData.append('To', to);
            formData.append('CallerId', this.callerId);
            formData.append('StatusCallback', `${process.env.SERVER_URL}/exotel/webhook`);
            formData.append('Record', 'true');
            // Remove the array notation for status callback events
            formData.append('StatusCallback.Events', 'completed,busy,no-answer,failed');
            // Add call type
            formData.append('CallType', 'trans');

            console.log('Making Exotel API request:', {
                url: `${this.baseUrl}/Calls/connect`,
                formData: formData.toString(),
                region: this.region,
                callerId: this.callerId
            });

            const response = await axios.post(`${this.baseUrl}/Calls/connect`,
                formData.toString(),
                {
                    auth: auth,
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'Accept': 'application/json'
                    }
                }
            );

            console.log('Exotel API Response:', response.data);
            return response.data;
        } catch (error) {
            console.error('Exotel call initiation error:', error.response?.data || error.message);
            if (error.response?.headers) {
                console.error('Response headers:', error.response.headers);
            }
            throw error;
        }
    }

    async getCallStatus(callSid) {
        try {
            const auth = {
                username: this.apiKey,
                password: this.token
            };

            const response = await axios.get(`${this.baseUrl}/Calls/${callSid}`, {
                auth: auth,
                headers: {
                    'Accept': 'application/json'
                }
            });
            return response.data;
        } catch (error) {
            console.error('Exotel call status error:', error.response?.data || error.message);
            throw error;
        }
    }

    async handleIncomingCall(req) {
        // Create ExoML response for voice streaming
        const response = `<?xml version="1.0" encoding="UTF-8"?>
            <Response>
                <Say>Welcome to the AI Assistant</Say>
                <Pause length="1"/>
                <Say>You can start speaking now</Say>
                <Connect>
                    <Stream url="wss://${req.headers.host}/exotel-stream" />
                </Connect>
            </Response>`;
        return response;
    }

    // Handle voice stream connection
    handleVoiceStream(ws, openAiWs) {
        ws.on('message', async (data) => {
            try {
                const message = JSON.parse(data);

                switch (message.event) {
                    case 'start':
                        console.log('Exotel stream started:', message.streamSid);
                        break;

                    case 'media':
                        // Convert Exotel's audio format to OpenAI compatible format
                        const audioBuffer = this._convertAudioFormat(message.media.payload);

                        // Send to OpenAI
                        if (openAiWs.readyState === WebSocket.OPEN) {
                            openAiWs.send(JSON.stringify({
                                type: 'input_audio_buffer.append',
                                audio: audioBuffer
                            }));
                        }
                        break;

                    case 'stop':
                        console.log('Exotel stream stopped');
                        break;
                }
            } catch (error) {
                console.error('Error processing Exotel message:', error);
            }
        });

        // Handle OpenAI responses
        openAiWs.on('message', (data) => {
            try {
                const response = JSON.parse(data);

                if (response.type === 'response.audio.delta' && response.delta) {
                    // Convert OpenAI audio to Exotel compatible format
                    const exotelAudio = this._convertToExotelFormat(response.delta);

                    // Send to Exotel
                    ws.send(JSON.stringify({
                        event: 'media',
                        media: {
                            payload: exotelAudio
                        }
                    }));
                }
            } catch (error) {
                console.error('Error processing OpenAI response:', error);
            }
        });
    }

    // Audio format conversion utilities
    _convertAudioFormat(audioData) {
        // Convert from Exotel's format (usually 8kHz PCM) to OpenAI compatible format
        // You'll need to implement the actual conversion logic based on Exotel's specs
        return audioData;
    }

    _convertToExotelFormat(audioData) {
        // Convert from OpenAI's format to Exotel compatible format
        // You'll need to implement the actual conversion logic based on Exotel's specs
        return audioData;
    }

    generateAuthToken() {
        const credentials = Buffer.from(`${this.sid}:${this.token}`).toString('base64');
        return `Basic ${credentials}`;
    }
}

module.exports = new ExotelService();