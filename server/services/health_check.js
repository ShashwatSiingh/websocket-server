const axios = require('axios');

const checkServerHealth = async () => {
  try {
    const primaryHealth = await axios.get(`${process.env.PRIMARY_SERVER_URL}/health`);
    const fallbackHealth = await axios.get(`${process.env.FALLBACK_SERVER_URL}/health`);

    console.log('Primary server status:', primaryHealth.data);
    console.log('Fallback server status:', fallbackHealth.data);

    return {
      primary: primaryHealth.data.status === 'healthy',
      fallback: fallbackHealth.data.status === 'healthy'
    };
  } catch (error) {
    console.error('Health check failed:', error);
    return {
      primary: false,
      fallback: false
    };
  }
};

// Run health check every 5 minutes
setInterval(checkServerHealth, 5 * 60 * 1000);