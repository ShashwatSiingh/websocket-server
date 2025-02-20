const exotelService = require('./services/exotel_service');
require('dotenv').config(); // Add this to load environment variables

// Verify environment variables are loaded
console.log('Environment check:', {
    haveSid: !!process.env.EXOTEL_SID,
    haveToken: !!process.env.EXOTEL_TOKEN,
    haveApiKey: !!process.env.EXOTEL_API_KEY,
    haveSubdomain: !!process.env.EXOTEL_SUBDOMAIN,
    haveRegion: !!process.env.EXOTEL_REGION,
    haveServerUrl: !!process.env.SERVER_URL
});

async function testCall() {
    try {
        // Use your verified number for receiving calls
        const from = "09513886363";  // Exotel caller ID
        const to = "+918825190385";  // Your number to receive the call

        console.log('Initiating call with parameters:', {
            from: from,
            to: to,
            callerId: process.env.EXOTEL_CALLER_ID,
            baseUrl: exotelService.baseUrl,
            region: exotelService.region
        });

        const response = await exotelService.initiateCall(from, to);
        console.log('Call initiated successfully:', response);

        if (response.Call && response.Call.Sid) {
            console.log('Call SID:', response.Call.Sid);
            console.log('Checking call status...');

            // Wait a moment before checking status
            await new Promise(resolve => setTimeout(resolve, 2000));

            const status = await exotelService.getCallStatus(response.Call.Sid);
            console.log('Call status:', status);
        }
    } catch (error) {
        console.error('Test failed:', error.message);
        if (error.response) {
            console.error('Error details:', {
                status: error.response.status,
                data: error.response.data,
                headers: error.response.headers
            });
        }
    }
}

testCall();