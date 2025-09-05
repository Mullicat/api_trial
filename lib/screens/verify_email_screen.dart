/**
 * VerifyEmailScreen - Email Verification Interface
 * 
 * This screen is shown when a user has signed up but hasn't verified
 * their email address yet. It provides options to:
 * - Check if email has been verified
 * - Resend verification email
 * - Return to login screen
 * 
 * The screen integrates with AuthViewModel to handle verification
 * status and provide real-time feedback to users.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch AuthViewModel for reactive UI updates
    final auth = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Verify your email')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Email icon for visual context
                const Icon(Icons.mark_email_unread_outlined, size: 72),
                const SizedBox(height: 16),

                // Show user's email address for confirmation
                Text(
                  'We sent a verification link to:\n${auth.currentUser?.email ?? ''}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Instructions for user
                const Text(
                  'Please open the link in your email. After verifying, return and tap the button below.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Error display
                if (auth.errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      auth.errorMessage!,
                      style: TextStyle(color: Colors.red.shade800),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Check verification button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: auth.isLoading
                        ? null
                        : () async {
                            await auth.reloadUser();
                            // The AuthWrapper will automatically navigate if verified
                          },
                    icon: auth.isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                    label: Text(
                      auth.isLoading
                          ? 'Checking...'
                          : 'I\'ve verified my email',
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Resend email button
                OutlinedButton.icon(
                  onPressed: auth.isLoading
                      ? null
                      : () async {
                          final email = auth.currentUser?.email;
                          if (email != null) {
                            await auth.sendEmailVerification(email);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Verification email sent! Check your inbox.',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                  icon: const Icon(Icons.send),
                  label: const Text('Resend verification email'),
                ),

                const SizedBox(height: 32),

                // Sign out option
                TextButton(
                  onPressed: auth.isLoading
                      ? null
                      : () async {
                          await auth.signOut();
                        },
                  child: const Text('Sign out and try again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
