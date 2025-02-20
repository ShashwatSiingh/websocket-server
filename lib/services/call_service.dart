import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/call_interaction.dart';

class CallService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // End a call
  Future<void> endCall(String callId) async {
    await _firestore
        .collection('calls')
        .doc(callId)
        .update({'status': 'Ended', 'endTime': Timestamp.now()});
  }

  // Send a message in call
  Future<void> sendMessage(String callId, String message) async {
    await _firestore.collection('calls').doc(callId).collection('messages').add({
      'content': message,
      'timestamp': Timestamp.now(),
      'type': 'supervisor',
    });
  }

  // Start monitoring a call
  Future<void> startMonitoring(String callId) async {
    await _firestore
        .collection('calls')
        .doc(callId)
        .update({'isMonitored': true});
  }

  // Stop monitoring a call
  Future<void> stopMonitoring(String callId) async {
    await _firestore
        .collection('calls')
        .doc(callId)
        .update({'isMonitored': false});
  }
}