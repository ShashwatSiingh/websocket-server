import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme/custom_theme.dart';
import '../services/call_handler_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final CallHandlerService _callHandler = CallHandlerService();
  final _phoneController = TextEditingController();
  String? _currentNumber;

  @override
  void initState() {
    super.initState();
    _loadCurrentNumber();
  }

  Future<void> _loadCurrentNumber() async {
    final number = await _callHandler.getCustomerCareNumber();
    setState(() {
      _currentNumber = number;
      _phoneController.text = number;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Appearance',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Theme Mode'),
                  subtitle: const Text('Choose your preferred theme'),
                  trailing: DropdownButton<ThemeMode>(
                    value: themeProvider.themeSettings.themeMode,
                    onChanged: (ThemeMode? newMode) {
                      if (newMode != null) {
                        themeProvider.updateThemeMode(newMode);
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('System'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Light'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Dark'),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text('Primary Color'),
                  subtitle: const Text('Choose your accent color'),
                  trailing: _buildColorPicker(context, themeProvider),
                ),
                SwitchListTile(
                  title: const Text('Material 3'),
                  subtitle: const Text('Use Material 3 design'),
                  value: themeProvider.themeSettings.useMaterial3,
                  onChanged: (bool value) {
                    themeProvider.updateUseMaterial3(value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Notifications',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Push Notifications'),
                  subtitle: const Text('Receive push notifications'),
                  value: true, // Connect to your notification settings
                  onChanged: (bool value) {
                    // Implement notification toggle
                  },
                ),
                SwitchListTile(
                  title: const Text('Email Notifications'),
                  subtitle: const Text('Receive email notifications'),
                  value: true, // Connect to your notification settings
                  onChanged: (bool value) {
                    // Implement notification toggle
                  },
                ),
              ],
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Customer Care Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Customer Care Number',
                      hintText: 'Enter phone number with country code',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await _callHandler.saveCustomerCareNumber(
                          _phoneController.text,
                        );
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Customer care number updated'),
                          ),
                        );
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                          ),
                        );
                      }
                    },
                    child: const Text('Save Number'),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Call Provider Settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Preferred Provider'),
                  subtitle: const Text('Choose your preferred call provider'),
                  trailing: FutureBuilder<String>(
                    future: _callHandler.getPreferredProvider(),
                    builder: (context, snapshot) {
                      return DropdownButton<String>(
                        value: snapshot.data ?? 'twilio',
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            _callHandler.setPreferredProvider(newValue);
                            setState(() {});
                          }
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'twilio',
                            child: Text('Twilio'),
                          ),
                          DropdownMenuItem(
                            value: 'exotel',
                            child: Text('Exotel'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker(BuildContext context, ThemeProvider themeProvider) {
    return PopupMenuButton<Color>(
      icon: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: themeProvider.themeSettings.primaryColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      onSelected: (Color color) {
        themeProvider.updatePrimaryColor(color);
      },
      itemBuilder: (BuildContext context) {
        return [
          const Color(0xFF1E88E5), // Blue
          const Color(0xFF43A047), // Green
          const Color(0xFFE53935), // Red
          const Color(0xFF8E24AA), // Purple
          const Color(0xFFF4511E), // Orange
        ].map((Color color) {
          return PopupMenuItem<Color>(
            value: color,
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(CustomTheme.getColorName(color)),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}