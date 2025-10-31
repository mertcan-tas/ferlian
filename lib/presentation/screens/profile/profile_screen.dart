import 'package:flutter/material.dart';
import 'package:ferlian/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../providers/auth/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        centerTitle: true,
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {
                // TODO: Navigate to settings when ready
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.6),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.settings,
                  size: 18,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            final userEmail = auth.session?.user.email ?? '-';
            final displayName = auth.session?.user.userMetadata?['full_name'] as String?;
            // Placeholder avatar; replace with user profile photo URL if available
            final photoUrl = auth.session?.user.userMetadata?['avatar_url'] as String?;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: theme.dividerColor.withValues(alpha: 0.3),
                      backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                          ? NetworkImage(photoUrl)
                          : null,
                      child: (photoUrl == null || photoUrl.isEmpty)
                          ? Icon(Icons.person, size: 44, color: colorScheme.primary)
                          : null,
                    ),
                    Positioned(
                      bottom: -2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '30%', // progress placeholder
                          style: theme.textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  displayName != null && displayName.isNotEmpty ? displayName : userEmail,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    l10n.profileSubtitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 16),
                Divider(height: 24, thickness: 0.8, color: theme.dividerColor.withValues(alpha: 0.4)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        leading: Icon(Icons.logout, color: colorScheme.error),
                        title: Text('Oturumu kapat', style: theme.textTheme.bodyLarge),
                        onTap: () async {
                          await context.read<AuthProvider>().signOut();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
