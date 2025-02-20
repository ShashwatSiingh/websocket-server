const axios = require('axios');

const BASE_URL = 'https://websocket-server-tq7k.onrender.com';
const TEST_DELAY = 1000; // Delay between tests

async function wait(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function testEndpoint(name, method, path, data = null) {
    try {
        console.log(`\nTesting ${name}...`);
        const config = {
            method,
            url: `${BASE_URL}${path}`,
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        };
        if (data) {
            config.data = data;
        }
        const response = await axios(config);
        console.log(`${name} response:`, {
            status: response.status,
            headers: response.headers,
            data: response.data
        });
        return true;
    } catch (error) {
        console.error(`${name} error:`, {
            status: error.response?.status,
            data: error.response?.data,
            message: error.message
        });
        return false;
    }
}

async function runTests() {
    try {
        // Test basic endpoints
        await testEndpoint('Root', 'GET', '/');
        await wait(TEST_DELAY);

        await testEndpoint('Health', 'GET', '/health');
        await wait(TEST_DELAY);

        await testEndpoint('Ping', 'GET', '/ping');
        await wait(TEST_DELAY);

        await testEndpoint('ExoML', 'GET', '/test-exoml');
        await wait(TEST_DELAY);

        // Test call endpoint
        await testEndpoint('Incoming Call', 'POST', '/exotel/incoming',
            'CallSid=test123&From=1234567890&To=09513886363'
        );

    } catch (error) {
        console.error('Test runner error:', error);
    }
}

// Run tests
console.log(`Testing server at ${BASE_URL}`);
runTests();