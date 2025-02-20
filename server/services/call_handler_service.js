const axios = require('axios');

const EXOTEL_API_BASE = `https://${process.env.EXOTEL_SID}:${process.env.EXOTEL_TOKEN}@${process.env.EXOTEL_SUBDOMAIN}.exotel.com/v1/Accounts/${process.env.EXOTEL_SID}`;

const handleIncomingCall = async (data, ws) => {
  try {
    // Extract call data
    const { callerId, recipientId, callType } = data;

    // Log incoming call
    console.log(`Incoming ${callType} call from ${callerId} to ${recipientId}`);

    // Initiate call via Exotel API
    const response = await axios.post(`${EXOTEL_API_BASE}/Calls/connect`, {
      From: callerId,
      To: recipientId,
      CallerId: process.env.EXOTEL_CALLER_ID,
      CallType: 'trans',
      StatusCallback: `${process.env.SERVER_URL}/exotel/webhook`
    });

    console.log('Exotel call initiated:', response.data);

    // Send call notification to client
    ws.send(JSON.stringify({
      type: 'call_initiated',
      data: {
        callerId,
        recipientId,
        callType,
        callSid: response.data.Call.Sid,
        timestamp: new Date().toISOString()
      }
    }));

    // Handle call based on type
    switch (callType) {
      case 'voice':
        // Handle voice call
        break;
      case 'video':
        // Handle video call
        break;
      default:
        throw new Error('Invalid call type');
    }

  } catch (error) {
    console.error('Error handling incoming call:', error);
    ws.send(JSON.stringify({
      type: 'error',
      message: 'Failed to initiate call'
    }));
  }
};

const handleExotelWebhook = async (webhookData, clients) => {
  const { CallSid, CallStatus, From, To } = webhookData;

  // Broadcast call status to all connected clients
  clients.forEach((ws) => {
    ws.send(JSON.stringify({
      type: 'call_status_update',
      data: {
        callSid: CallSid,
        status: CallStatus,
        from: From,
        to: To,
        timestamp: new Date().toISOString()
      }
    }));
  });
};

module.exports = {
  handleIncomingCall,
  handleExotelWebhook
};