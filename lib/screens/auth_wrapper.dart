import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'login_screen.dart';
import 'main_navigation.dart';
import 'verify_email_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        if (!authViewModel.isInitialized ||
            (authViewModel.isLoading && authViewModel.currentUser == null)) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Initializing...'),
                ],
              ),
            ),
          );
        }

        if (authViewModel.errorMessage != null &&
            !authViewModel.isAuthenticated) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error: ${authViewModel.errorMessage}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      authViewModel.clearError();
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (authViewModel.isAuthenticated) {
          // Check if email is verified for authenticated users
          if (authViewModel.isEmailVerified == true) {
            return const MainNavigation();
          } else {
            return const VerifyEmailScreen();
          }
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
