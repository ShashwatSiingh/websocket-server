const handleIncomingCall = async (data, ws) => {
  try {
    // Extract call data
    const { callerId, recipientId, callType } = data;

    // Log incoming call
    console.log(`Incoming ${callType} call from ${callerId} to ${recipientId}`);

    // Send call notification to client
    ws.send(JSON.stringify({
      type: 'call_notification',
      data: {
        callerId,
        recipientId,
        callType,
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
      message: 'Failed to process incoming call'
    }));
  }
};

module.exports = {
  handleIncomingCall
};