import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';

class AiCallService {
  static const String SYSTEM_MESSAGE = 'You are a helpful and bubbly AI assistant who loves to chat about anything the user is interested about and is prepared to offer them facts. You have a penchant for dad jokes, owl jokes, and rickrolling – subtly. Always stay positive, but work in a joke when appropriate.';

  WebSocketChannel? _openAiWs;
  WebSocketChannel? _twilioWs;
  String? _streamSid;
  int _latestMediaTimestamp = 0;
  String? _lastAssistantItem;

  Future<void> initializeOpenAI() async {
    final wsUrl = Uri.parse('wss://api.openai.com/v1/realtime?model=gpt-4o-realtime-preview-2024-10-01');

    _openAiWs = WebSocketChannel.connect(
      wsUrl,
      protocols: ['Bearer ${Constants.OPENAI_API_KEY}'],
    );

    // Initialize session
    _openAiWs?.sink.add(jsonEncode({
      'type': 'session.update',
      'session': {
        'turn_detection': {'type': 'server_vad'},
        'speech': {'model': 'whisper-1'},
        'system_message': SYSTEM_MESSAGE,
        'voice': 'alloy',
      }
    }));

    _listenToOpenAI();
  }

  void _listenToOpenAI() {
    _openAiWs?.stream.listen(
      (message) {
        final data = jsonDecode(message);
        _handleOpenAIMessage(data);
      },
      onError: (error) {
        print('OpenAI WebSocket error: $error');
      },
      onDone: () {
        print('OpenAI WebSocket connection closed');
      },
    );
  }

  void _handleOpenAIMessage(Map<String, dynamic> data) {
    if (data['type'] == 'response.content.delta') {
      // Handle AI response
      if (_twilioWs != null) {
        _twilioWs?.sink.add(jsonEncode({
          'event': 'media',
          'streamSid': _streamSid,
          'media': {
            'payload': data['delta']
          }
        }));
      }
    }
  }

  Future<void> handleIncomingCall(String phoneNumber) async {
    // Initialize Twilio WebSocket connection
    final twilioWsUrl = Uri.parse('wss://${Constants.TWILIO_DOMAIN}/media-stream');
    _twilioWs = WebSocketChannel.connect(twilioWsUrl);

    _listenToTwilio();
  }

  void _listenToTwilio() {
    _twilioWs?.stream.listen(
      (message) {
        final data = jsonDecode(message);
        _handleTwilioMessage(data);
      },
      onError: (error) {
        print('Twilio WebSocket error: $error');
      },
      onDone: () {
        print('Twilio WebSocket connection closed');
      },
    );
  }

  void _handleTwilioMessage(Map<String, dynamic> data) {
    switch (data['event']) {
      case 'media':
        _latestMediaTimestamp = data['media']['timestamp'];
        if (_openAiWs != null) {
          _openAiWs?.sink.add(jsonEncode({
            'type': 'input_audio_buffer.append',
            'audio': data['media']['payload']
          }));
        }
        break;
      case 'start':
        _streamSid = data['start']['streamSid'];
        print('Incoming stream started: $_streamSid');
        break;
    }
  }

  void dispose() {
    _openAiWs?.sink.close();
    _twilioWs?.sink.close();
  }
}