/**
 * main.dart - Application Entry Point
 * 
 * This file sets up the Flutter application with the necessary providers
 * and configuration. It establishes the app-wide state management using
 * the Provider package for dependency injection and state management.
 * 
 * Architecture Overview:
 * - Provider package for state management (MVVM pattern)
 * - AuthViewModel manages global authentication state
 * - AuthWrapper handles routing based on auth state
 * - Material 3 design system for modern UI
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'screens/auth_wrapper.dart';

/**
 * Application entry point
 * 
 * main() is the first function called when the app starts.
 * WidgetsFlutterBinding.ensureInitialized() ensures that the Flutter
 * framework is properly initialized before running the app.
 * 
 * This is required when calling Flutter services before runApp(),
 * though in this case it's good practice for future extensibility.
 */
void main() async {
  // Ensure Flutter framework is initialized
  // Required for calling Flutter services in main() before runApp()
  WidgetsFlutterBinding.ensureInitialized();

  // Start the Flutter application
  runApp(const MyApp());
}

/**
 * MyApp - Root Application Widget
 * 
 * This widget sets up:
 * 1. State management providers (AuthViewModel)
 * 2. App-wide theme and configuration
 * 3. Navigation and routing setup
 * 
 * The ChangeNotifierProvider makes AuthViewModel available to all
 * descendant widgets in the widget tree, enabling reactive UI updates
 * when authentication state changes.
 */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider sets up state management for the entire app
    // This makes AuthViewModel available to all child widgets
    return ChangeNotifierProvider(
      // Create AuthViewModel instance - this will automatically call
      // its constructor which initializes authentication
      create: (context) => AuthViewModel(),

      child: MaterialApp(
        title: 'API Trial',

        // Material 3 theme configuration
        theme: ThemeData(
          // Generate color scheme from seed color
          // This creates a cohesive color palette following Material 3 guidelines
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 171, 78, 199),
          ),
          useMaterial3: true, // Enable Material 3 design system
        ),

        // AuthWrapper handles routing based on authentication state
        // It will show login/signup screens for unauthenticated users
        // and main app content for authenticated users
        home: const AuthWrapper(),

        // Remove debug banner in top-right corner
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
