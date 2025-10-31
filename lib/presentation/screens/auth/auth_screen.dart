import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth/auth_provider.dart';
import '../../providers/ui/bottom_nav_provider.dart';
import 'widgets/login_form.dart';
import 'widgets/register_form.dart';

enum AuthMode { login, register }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.initialMode = AuthMode.login});

  final AuthMode initialMode;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _showLogin;
  bool _hasHandledAuthNavigation = false;

  @override
  void initState() {
    super.initState();
    _showLogin = widget.initialMode == AuthMode.login;
  }

  void _toggle() {
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final auth = context.watch<AuthProvider>();
    final bottomNav = context.read<BottomNavProvider>();

    if (auth.isAuthenticated && !_hasHandledAuthNavigation) {
      _hasHandledAuthNavigation = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        bottomNav.setIndex(0);
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
    } else if (!auth.isAuthenticated && _hasHandledAuthNavigation) {
      _hasHandledAuthNavigation = false;
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
        title: Text(
          _showLogin ? 'Giriş Yap' : 'Kayıt Ol',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.security_rounded,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _showLogin ? 'Tekrar Hoş Geldin' : 'Aramıza Katıl',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _showLogin
                        ? 'Devam etmek için e-posta ve şifrenle giriş yap.'
                        : 'Supabase destekli hesabını birkaç saniyede oluştur.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withValues(
                        alpha: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: _showLogin
                        ? LoginForm(
                            key: const ValueKey('login_form'),
                            onRegisterRequested: _toggle,
                          )
                        : RegisterForm(
                            key: const ValueKey('register_form'),
                            onLoginRequested: _toggle,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
