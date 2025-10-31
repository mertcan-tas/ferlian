import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth/auth_provider.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
          'Ayarlar',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final session = auth.session;
          final metadata = session?.user.userMetadata ?? <String, dynamic>{};
          final avatarUrl = metadata['avatar_url'] as String?;
          final fullName = (metadata['full_name'] as String?)?.trim();
          final email = session?.user.email ?? '-';

          void openEditProfile() {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const EditProfileScreen()),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: theme.dividerColor.withOpacity(0.2),
                    backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                        ? NetworkImage(avatarUrl)
                        : null,
                    child: (avatarUrl == null || avatarUrl.isEmpty)
                        ? Icon(Icons.person, color: colorScheme.primary)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (fullName != null && fullName.isNotEmpty)
                              ? fullName
                              : email,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: openEditProfile,
                    child: const Text('Düzenle'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _SectionLabel(label: 'HESAP'),
              _SettingsTile(
                icon: Icons.person_outline,
                title: 'Kişisel Bilgiler',
                subtitle: 'İsim, kullanıcı adı ve doğum tarihi',
                onTap: openEditProfile,
              ),
              _SettingsTile(
                icon: Icons.credit_card,
                title: 'Ödeme ve Abonelik',
                subtitle: 'Hesap tercihlerin',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Bildirim Ayarları',
                subtitle: 'Albüm, anılar ve bildirimler',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.lock_outline,
                title: 'Hesap Tercihleri',
                subtitle: 'Giriş yöntemi ve güvenlik',
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _SectionLabel(label: 'UYGULAMA'),
              _SettingsTile(
                icon: Icons.support_agent_outlined,
                title: 'Destek',
                subtitle: 'Veri tercihleri ve depolama',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.help_outline,
                title: 'Yardım Merkezi',
                subtitle: 'Ferlian nasıl çalışır?',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.share_outlined,
                title: 'Paylaş',
                subtitle: 'Ferlian’ı arkadaşlarına davet et',
                onTap: () {},
              ),
            ],
          );
        },
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

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: colorScheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
