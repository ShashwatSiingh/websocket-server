class Constants {
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 12.0;
  static const double defaultSpacing = 24.0;

  static const List<String> filterOptions = [
    'All',
    'Urgent',
    'Pending',
    'Completed',
    'AI Handled',
    'Human Required',
  ];

  static const List<String> todoItems = [
    'Follow up with Customer #123',
    'Review sales report',
    'Team meeting at 2 PM',
    'Update customer database',
    'Prepare weekly analytics',
  ];

  static const String OPENAI_API_KEY = 'your_openai_api_key';
  static const String TWILIO_DOMAIN = 'your_twilio_domain';
  static const String TWILIO_ACCOUNT_SID = 'your_twilio_account_sid';
  static const String TWILIO_AUTH_TOKEN = 'your_twilio_auth_token';
}