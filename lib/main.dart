import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/dashboard_screen.dart';
import 'services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'providers/dashboard_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/todo_provider.dart';
import 'theme/app_theme.dart';
import 'utils/navigator_key.dart';
import 'package:logging/logging.dart';

Widget defaultErrorWidget(String message) {
  return Material(
    child: Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Setup logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final _log = Logger('Main');

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _log.info('Firebase initialized successfully');

    try {
      await FirebaseFirestore.instance.collection('test').doc('test').get();
      _log.info('Firestore connection successful');
    } catch (e) {
      _log.severe('Firestore connection error', e);
      ErrorWidget.builder = (FlutterErrorDetails details) {
        return defaultErrorWidget(
            'Database connection error.\nPlease check your internet connection.');
      };
    }

    // Run app only after Firebase is initialized
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => DashboardProvider()),
          ChangeNotifierProvider(create: (_) => TodoProvider()),
        ],
        child: MyApp(),
      ),
    );
  } catch (e) {
    _log.severe('Firebase initialization error', e);
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return defaultErrorWidget(
          'Failed to initialize Firebase.\nPlease restart the app.');
    };
    // Still run the app, but with error state
    runApp(
      MaterialApp(
        home: defaultErrorWidget(
            'Failed to initialize Firebase.\nPlease restart the app.'),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'AI Support Dashboard',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: AppTheme.lightTheme.copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: themeProvider.themeSettings.primaryColor,
            ).copyWith(
              secondary: themeProvider.themeSettings.primaryColor,
            ),
            useMaterial3: themeProvider.themeSettings.useMaterial3,
          ),
          darkTheme: AppTheme.darkTheme.copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: themeProvider.themeSettings.primaryColor,
              brightness: Brightness.dark,
            ).copyWith(
              secondary: themeProvider.themeSettings.primaryColor,
            ),
            useMaterial3: themeProvider.themeSettings.useMaterial3,
          ),
          builder: (context, child) {
            // Add error boundary
            return ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(
                physics: const BouncingScrollPhysics(),
              ),
              child: child!,
            );
          },
          home: StreamBuilder<User?>(
            stream: _authService.authStateChanges,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading...'),
                      ],
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              }

              if (snapshot.hasData) {
                return DashboardScreen();
              }

              return LoginPage();
            },
          ),
          routes: {
            '/login': (context) => LoginPage(),
            '/signup': (context) => SignupPage(),
            '/dashboard': (context) => DashboardScreen(),
          },
        );
      },
    );
  }
}
