import axios from 'axios';
import WebSocket from 'ws';

class ExotelService {
    constructor(sid, token, subdomain) {
        this.sid = sid;
        this.token = token;
        this.subdomain = subdomain;
        this.baseUrl = `https://${sid}:${token}@${subdomain}.exotel.in/v1/Accounts/${sid}`;
        this.appId = process.env.EXOTEL_APP_ID;
    }

    async makeCall(from, to, callbackUrl) {
        try {
            const response = await axios.post(`${this.baseUrl}/Calls/connect`, {
                From: from,
                To: to,
                CallerId: from,
                Url: callbackUrl,
                StatusCallback: `${callbackUrl}/status`
            });
            return response.data;
        } catch (error) {
            console.error('Exotel call error:', error);
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

export default ExotelService;