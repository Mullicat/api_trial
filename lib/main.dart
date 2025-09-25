// main.dart - Entry point for the Flutter app
// Sets up state management with Provider and Material 3 UI

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'screens/auth_wrapper.dart';

// App entry point
// Initializes Flutter and starts the app
void main() async {
  // Initialize Flutter framework
  WidgetsFlutterBinding.ensureInitialized();

  // Start the app
  runApp(const MyApp());
}

// MyApp - Root widget for the app
// Configures state management, theme, and routing
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set up global state management with Provider
    return ChangeNotifierProvider(
      // Create AuthViewModel to manage authentication state
      create: (context) => AuthViewModel(),
      child: MaterialApp(
        title: 'API Trial', // App name
        // Material 3 theme with custom purple color scheme
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 171, 78, 199),
          ),
          useMaterial3: true,
        ),
        // AuthWrapper handles routing based on auth state
        home: const AuthWrapper(),
        // Hide debug banner
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
