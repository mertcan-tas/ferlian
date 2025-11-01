import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import 'en/app_localizations_en.dart';
import 'tr/app_localizations_tr.dart';

/// Base localization class with access helpers and string contracts.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale);

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  static Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(
      lookupAppLocalizations(locale),
    );
  }

  static bool isSupported(Locale locale) {
    return supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
  }

  String get homeTitle;
  String get homeSubtitle;
  String get exploreTitle;
  String get exploreSubtitle;
  String get messagesTitle;
  String get messagesSubtitle;
  String get profileTitle;
  String get profileSubtitle;
  String get navDiscover;
  String get navMatches;
  String get navChat;
  String get navProfile;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) =>
      AppLocalizations.load(locale);

  @override
  bool isSupported(Locale locale) => AppLocalizations.isSupported(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale".',
  );
}
