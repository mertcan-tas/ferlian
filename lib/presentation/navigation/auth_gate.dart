import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth/auth_provider.dart';
import 'app_shell.dart';
import '../screens/auth/auth_landing_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        switch (auth.status) {
          case AuthStatus.unknown:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case AuthStatus.authenticated:
            return const AppShell();
          case AuthStatus.unauthenticated:
            return const AuthLandingScreen();
        }
      },
    );
  }
}
