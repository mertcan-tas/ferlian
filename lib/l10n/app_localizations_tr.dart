// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get homeTitle => 'Ana Sayfa';

  @override
  String get homeSubtitle => 'Uygulamanın ana sekmesine hoş geldin.';

  @override
  String get exploreTitle => 'Keşfet';

  @override
  String get exploreSubtitle =>
      'Yeni içerikleri ve fırsatları burada bulabilirsin.';

  @override
  String get messagesTitle => 'Mesajlar';

  @override
  String get messagesSubtitle =>
      'Arkadaşlarınla iletişim kurmak için mesajlarını kontrol et.';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileSubtitle =>
      'Kişisel bilgilerini düzenlemek için bu sayfayı kullan.';

  @override
  String get navDiscover => 'Keşfet';

  @override
  String get navMatches => 'Eşleşmeler';

  @override
  String get navChat => 'Sohbet';

  @override
  String get navProfile => 'Profil';
}
