import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _birthdayController;
  late final TextEditingController _genderController;
  late final TextEditingController _addressController;
  late final TextEditingController _countryController;
  late final TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final session = auth.session;
    final metadata = session?.user.userMetadata ?? <String, dynamic>{};

    final fullName = (metadata['full_name'] as String?)?.trim() ?? '';
    _nameController = TextEditingController(text: fullName);
    _emailController = TextEditingController(text: session?.user.email ?? '');
    _birthdayController = TextEditingController(
      text: (metadata['birthday'] as String?) ?? '',
    );
    _genderController = TextEditingController(
      text: (metadata['gender'] as String?) ?? '',
    );
    _addressController = TextEditingController(
      text: (metadata['address'] as String?) ?? '',
    );
    _countryController = TextEditingController(
      text: (metadata['country'] as String?) ?? '',
    );
    _cityController = TextEditingController(
      text: (metadata['city'] as String?) ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _birthdayController.dispose();
    _genderController.dispose();
    _addressController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final auth = Provider.of<AuthProvider>(context);
    final session = auth.session;
    final metadata = session?.user.userMetadata ?? <String, dynamic>{};
    final avatarUrl = metadata['avatar_url'] as String?;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'Profili Düzenle',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final authProvider = context.read<AuthProvider>();
              final name = _nameController.text.trim();
              final email = _emailController.text.trim();

              await authProvider.updateCachedProfile(
                fullName: name.isEmpty ? null : name,
                email: email.isEmpty ? null : email,
              );

              if (!mounted) return;
              navigator.pop();
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: theme.dividerColor.withValues(alpha: 0.2),
                    backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                        ? NetworkImage(avatarUrl)
                        : null,
                    child: (avatarUrl == null || avatarUrl.isEmpty)
                        ? Icon(
                            Icons.person,
                            size: 40,
                            color: colorScheme.primary,
                          )
                        : null,
                  ),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _SectionLabel(label: 'KİŞİSEL BİLGİLER'),
            _LabeledField(label: 'Tam Ad', controller: _nameController),
            _LabeledField(
              label: 'E-posta Adresi',
              controller: _emailController,
              readOnly: true,
            ),
            _LabeledField(
              label: 'Doğum Tarihi',
              controller: _birthdayController,
              suffixIcon: Icons.calendar_today_rounded,
            ),
            _LabeledField(
              label: 'Cinsiyet',
              controller: _genderController,
              suffixIcon: Icons.keyboard_arrow_down_rounded,
            ),
            const SizedBox(height: 16),
            _SectionLabel(label: 'ADRES'),
            _LabeledField(
              label: 'Adres Satırı',
              controller: _addressController,
            ),
            _LabeledField(label: 'Ülke', controller: _countryController),
            _LabeledField(label: 'Şehir', controller: _cityController),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.suffixIcon,
  });

  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final IconData? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            readOnly: readOnly,
            decoration: InputDecoration(
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.4,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              suffixIcon: suffixIcon != null
                  ? Icon(suffixIcon, color: colorScheme.primary)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
