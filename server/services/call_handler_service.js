const exotelService = require('./exotel_service');

const handleIncomingCall = async (data, ws) => {
  try {
    // Extract call data
    const { callerId, recipientId, callType } = data;

    // Log incoming call
    console.log(`Incoming ${callType} call from ${callerId} to ${recipientId}`);

    // Initiate call via Exotel
    const callResponse = await exotelService.initiateCall(callerId, recipientId);

    // Send call initiated notification
    ws.send(JSON.stringify({
      type: 'call_initiated',
      data: {
        callerId,
        recipientId,
        callType,
        callSid: callResponse.Call.Sid,
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
  try {
    const { CallSid, CallStatus, From, To } = webhookData;
    console.log('Exotel webhook received:', webhookData);

    // Get detailed call status
    const callDetails = await exotelService.getCallStatus(CallSid);

    // Broadcast to all connected clients
    clients.forEach((ws) => {
      ws.send(JSON.stringify({
        type: 'call_status_update',
        data: {
          callSid: CallSid,
          status: CallStatus,
          from: From,
          to: To,
          details: callDetails,
          timestamp: new Date().toISOString()
        }
      }));
    });

  } catch (error) {
    console.error('Error handling Exotel webhook:', error);
  }
};

module.exports = {
  handleIncomingCall,
  handleExotelWebhook
};