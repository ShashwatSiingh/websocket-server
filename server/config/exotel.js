export const exotelConfig = {
    // Audio settings
    audioFormat: {
        sampleRate: 8000,
        channels: 1,
        codec: 'PCMU',
        bitRate: 64000
    },

    // Call settings
    callSettings: {
        recordCall: true,
        fallbackUrl: 'https://your-server-url/exotel/fallback',
        statusCallback: 'https://your-server-url/exotel/status'
    }
};