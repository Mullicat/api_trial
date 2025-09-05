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
 * This function sets up the entire application environment before
 * the UI is rendered.
 * 
 * Key initialization steps:
 * 1. WidgetsFlutterBinding.ensureInitialized() - Prepares Flutter framework
 * 2. runApp() - Inflates the widget tree and starts the app
 * 
 * The async keyword allows for future async initialization (like loading
 * environment variables, setting up databases, etc.)
 */
void main() async {
  // Ensure Flutter framework is initialized
  // This is critical when calling Flutter services in main() before runApp()
  // Examples: SharedPreferences, SystemChrome, Firebase initialization
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Add any app-wide initialization here (Firebase, Supabase, etc.)
  // Example: await Firebase.initializeApp();
  // Example: await dotenv.load();

  // Start the Flutter application
  // This creates the widget tree and begins the app lifecycle
  runApp(const MyApp());
}

/**
 * MyApp - Root Application Widget
 * 
 * This is the top-level widget that configures the entire application.
 * It's responsible for:
 * 
 * 1. State Management Setup:
 *    - ChangeNotifierProvider creates and provides AuthViewModel globally
 *    - All descendant widgets can access auth state via Provider.of/Consumer
 * 
 * 2. App Configuration:
 *    - Material 3 theme with custom color scheme
 *    - App title and debug settings
 *    - Initial route determination via AuthWrapper
 * 
 * 3. Navigation Architecture:
 *    - AuthWrapper acts as the root navigator
 *    - Handles auth-based routing (login vs main app)
 *    - Supports email verification flow
 * 
 * Design Pattern: Provider + MVVM
 * - Provider: Dependency injection and state management
 * - MVVM: Separation of UI (View) and business logic (ViewModel)
 */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider: Global state management setup
    // This creates AuthViewModel and makes it available to the entire widget tree
    // Benefits:
    // - Automatic UI updates when auth state changes (reactive programming)
    // - Single source of truth for authentication state
    // - Easy access from any descendant widget via context.watch/read
    return ChangeNotifierProvider(
      // Create AuthViewModel instance - constructor automatically:
      // 1. Initializes Supabase connection
      // 2. Checks for existing user session
      // 3. Sets up auth state change listeners
      // 4. Handles email verification status
      create: (context) => AuthViewModel(),

      child: MaterialApp(
        title: 'API Trial', // App name shown in task switcher
        // Material 3 Theme Configuration
        theme: ThemeData(
          // Seed-based color scheme: generates entire palette from one color
          // Material 3 creates consistent colors for primary, secondary, surface, etc.
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 171, 78, 199), // Purple theme
          ),
          useMaterial3: true, // Enable latest Material Design system
          // Additional theme customizations can be added here:
          // appBarTheme: AppBarTheme(...),
          // elevatedButtonTheme: ElevatedButtonThemeData(...),
        ),

        // AuthWrapper: Smart routing based on authentication state
        // Navigation logic:
        // - No user -> LoginScreen
        // - User exists but email not verified -> VerifyEmailScreen
        // - User exists and email verified -> MainNavigation
        // This eliminates the need for manual navigation checks throughout the app
        home: const AuthWrapper(),

        // Development settings
        debugShowCheckedModeBanner:
            false, // Remove debug banner in release builds
      ),
    );
  }
}
