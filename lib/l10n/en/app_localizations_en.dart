// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import '../app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeTitle => 'Home';

  @override
  String get homeSubtitle => 'Welcome to the main section of the app.';

  @override
  String get exploreTitle => 'Discover';

  @override
  String get exploreSubtitle => 'Find new content and opportunities here.';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get messagesSubtitle =>
      'Check your messages to stay in touch with friends.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileSubtitle =>
      'Use this page to edit your personal information.';

  @override
  String get navDiscover => 'Discover';

  @override
  String get navMatches => 'Matches';

  @override
  String get navChat => 'Chat';

  @override
  String get navProfile => 'Profile';
}
