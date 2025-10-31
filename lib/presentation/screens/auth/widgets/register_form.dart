import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import 'auth_text_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key, required this.onLoginRequested});

  final VoidCallback onLoginRequested;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Batu J');
  final _emailController = TextEditingController(text: 'batu.j@azdim.net');
  final _passwordController = TextEditingController(text: 'Naga_9192#*');
  final _confirmPasswordController = TextEditingController(text: 'Naga_9192#*');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    final auth = context.read<AuthProvider>();
    final success = await auth.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      fullName: _nameController.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      if (!auth.isAuthenticated) {
        _showSnackBar(
          'Kayıt isteğin oluşturuldu. E-postanı kontrol edip doğrulayabilirsin.',
        );
        widget.onLoginRequested();
      }
    } else if (auth.errorMessage != null) {
      _showSnackBar(auth.errorMessage!);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // optional field
    }
    if (value.trim().length < 2) {
      return 'İsim en az 2 karakter olmalı.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-posta adresini gir.';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Geçerli bir e-posta adresi yaz.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre oluştur.';
    }
    if (value.length < 6) {
      return 'Şifre en az 6 karakter olmalı.';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifreyi doğrula.';
    }
    if (value != _passwordController.text) {
      return 'Şifreler eşleşmiyor.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthTextField(
              controller: _nameController,
              label: 'Ad Soyad (Opsiyonel)',
              keyboardType: TextInputType.name,
              validator: _validateName,
              autofillHints: const [AutofillHints.name],
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _emailController,
              label: 'E-posta',
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
              autofillHints: const [AutofillHints.email],
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _passwordController,
              label: 'Şifre',
              obscureText: true,
              validator: _validatePassword,
              autofillHints: const [AutofillHints.newPassword],
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _confirmPasswordController,
              label: 'Şifreyi Doğrula',
              obscureText: true,
              validator: _validateConfirmPassword,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              autofillHints: const [AutofillHints.newPassword],
            ),
            if (auth.errorMessage != null && !auth.isBusy) ...[
              const SizedBox(height: 12),
              Text(
                auth.errorMessage!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: auth.isBusy ? null : _submit,
              child: auth.isBusy
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Kayıt Ol'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: auth.isBusy
                  ? null
                  : () {
                      context.read<AuthProvider>().clearError();
                      widget.onLoginRequested();
                    },
              child: const Text('Zaten hesabın var mı? Giriş yap'),
            ),
          ],
        ),
      ),
    );
  }
}
