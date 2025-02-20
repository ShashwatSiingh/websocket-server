import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ai_call_service.dart';

class CallHandlerService {
  final AiCallService _aiCallService = AiCallService();
  static const String _customerCareNumberKey = 'customer_care_number';
  static const String _preferredProviderKey = 'preferred_provider';

  // Provider numbers
  static const String twilioNumber = '+16824247379';
  static const String exotelNumber = '+919XXXXXXXX'; // Your Exotel number

  // Make a phone call
  Future<void> makePhoneCall(String phoneNumber, {bool useAI = false}) async {
    if (useAI) {
      final provider = await getPreferredProvider();
      phoneNumber = provider == 'twilio' ? twilioNumber : exotelNumber;
    }

    final formattedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri telUri = Uri(scheme: 'tel', path: formattedNumber);

    try {
      if (!await launchUrl(telUri,
          mode: LaunchMode.externalNonBrowserApplication)) {
        throw 'Could not launch dialer';
      }
    } catch (e) {
      final String telUrl = 'tel:$formattedNumber';
      if (!await launchUrl(Uri.parse(telUrl),
          mode: LaunchMode.externalNonBrowserApplication)) {
        throw 'Could not launch phone dialer: $e';
      }
    }
  }

  // Save customer care number
  Future<void> saveCustomerCareNumber(String number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customerCareNumberKey, number);
  }

  // Get saved customer care number
  Future<String> getCustomerCareNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_customerCareNumberKey) ?? defaultCustomerCareNumber;
  }

  // Request necessary permissions
  Future<bool> requestPermissions() async {
    try {
      final permissions = await [
        Permission.phone,
        Permission.microphone,
        Permission.audio,
        Permission.bluetoothConnect,
      ].request();

      // Log permission status
      permissions.forEach((permission, status) {
        print('Permission $permission: $status');
      });

      return permissions.values.every((status) => status.isGranted);
    } catch (e) {
      print('Permission Error: $e');
      return false;
    }
  }

  // Test AI call
  Future<void> testAICall() async {
    try {
      final hasPermissions = await requestPermissions();
      if (!hasPermissions) {
        throw 'Required permissions not granted';
      }

      // Initialize AI service first
      await _aiCallService.initializeOpenAI();

      print('Making call to Twilio number: $twilioNumber');
      await makePhoneCall(twilioNumber, useAI: true);
    } catch (e) {
      print('AI Call Error: $e'); // Add logging
      throw 'Failed to make AI test call: $e';
    }
  }

  // Get preferred provider (Twilio or Exotel)
  Future<String> getPreferredProvider() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_preferredProviderKey) ?? 'twilio';
  }

  // Set preferred provider
  Future<void> setPreferredProvider(String provider) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_preferredProviderKey, provider);
  }

  void dispose() {
    _aiCallService.dispose();
  }

  static const String defaultCustomerCareNumber =
      '+918825190385'; // Your number
}
