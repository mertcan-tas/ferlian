import 'package:flutter/material.dart';

import 'package:ferlian/l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import 'detail/chat_detail_screen.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.messagesTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 92,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _stories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final story = _stories[index];
                    final isAdd = story.isAddButton;
                    return Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: isAdd
                                    ? null
                                    : const LinearGradient(
                                        colors: [
                                          Color(0xFF8E2DE2),
                                          Color(0xFF4A00E0),
                                        ],
                                      ),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.surface,
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    story.avatarAsset,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            if (isAdd)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: colorScheme.surface,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          story.name,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Arkadaşını veya eşleşmeni ara',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 26,
                        backgroundImage: AssetImage(message.avatarAsset),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            message.name,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            message.timeLabel,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        message.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: ChatDetailScreen(
                            partnerName: message.name,
                            partnerAvatar: message.avatarAsset,
                            lastSeenLabel: message.timeLabel,
                          ),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Story {
  const _Story({
    required this.name,
    required this.avatarAsset,
    this.isAddButton = false,
  });

  final String name;
  final String avatarAsset;
  final bool isAddButton;
}

class _MessagePreview {
  const _MessagePreview({
    required this.name,
    required this.lastMessage,
    required this.timeLabel,
    required this.avatarAsset,
  });

  final String name;
  final String lastMessage;
  final String timeLabel;
  final String avatarAsset;
}

const _stories = <_Story>[
  _Story(
    name: 'Benim Hikayem',
    avatarAsset: 'assets/bg/auth-landing-bg.jpg',
    isAddButton: true,
  ),
  _Story(name: 'Olivia', avatarAsset: 'assets/bg/auth-landing-bg.jpg'),
  _Story(name: 'Williams', avatarAsset: 'assets/bg/auth-landing-bg.jpg'),
  _Story(name: 'Ava', avatarAsset: 'assets/bg/auth-landing-bg.jpg'),
  _Story(name: 'Mia', avatarAsset: 'assets/bg/auth-landing-bg.jpg'),
];

const _messages = <_MessagePreview>[
  _MessagePreview(
    name: 'Olivia',
    lastMessage: 'Hey! Nasılsın?',
    timeLabel: 'Şimdi',
    avatarAsset: 'assets/bg/auth-landing-bg.jpg',
  ),
  _MessagePreview(
    name: 'Rihana',
    lastMessage: 'Son mesajımı alabildin mi?',
    timeLabel: '5 dakika önce',
    avatarAsset: 'assets/bg/auth-landing-bg.jpg',
  ),
  _MessagePreview(
    name: 'Ava',
    lastMessage: 'Yakında görüşelim! 😊',
    timeLabel: '10 dakika önce',
    avatarAsset: 'assets/bg/auth-landing-bg.jpg',
  ),
  _MessagePreview(
    name: 'Williams',
    lastMessage: 'Günün nasıl geçiyor? 🌞',
    timeLabel: '1 saat önce',
    avatarAsset: 'assets/bg/auth-landing-bg.jpg',
  ),
  _MessagePreview(
    name: 'Kiara',
    lastMessage: 'Bu hafta sonu müsait misin? 🎉',
    timeLabel: '3 saat önce',
    avatarAsset: 'assets/bg/auth-landing-bg.jpg',
  ),
];
