import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Generated localization class for Qari2
/// Provides access to all localized strings
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Helper methods for each string (examples - in real app would be generated)
  String get appName => Intl.message('Qari2', name: 'appName');
  String get appTagline =>
      Intl.message('Your smart Arabic document companion.', name: 'appTagline');

  String get onboardingTitle1 =>
      Intl.message('Read and understand any document', name: 'onboardingTitle1');
  String get onboardingSubtitle1 => Intl.message(
      'Import PDFs and scans in Arabic & English',
      name: 'onboardingSubtitle1');

  String get onboardingTitle2 =>
      Intl.message('Ask questions instead of scrolling', name: 'onboardingTitle2');
  String get onboardingSubtitle2 => Intl.message(
      'Semantic search, summaries, and AI Q&A',
      name: 'onboardingSubtitle2');

  String get onboardingTitle3 =>
      Intl.message('Study and work faster on the go', name: 'onboardingTitle3');
  String get onboardingSubtitle3 => Intl.message(
      'Your documents, always with you on mobile',
      name: 'onboardingSubtitle3');

  String get getStarted => Intl.message('Get Started', name: 'getStarted');
  String get skip => Intl.message('Skip', name: 'skip');
  String get next => Intl.message('Next', name: 'next');

  String get myLibrary => Intl.message('My Library', name: 'myLibrary');
  String get addDocument => Intl.message('Add Document', name: 'addDocument');
  String get searchDocuments =>
      Intl.message('Search documents...', name: 'searchDocuments');

  String get aiSummary => Intl.message('Summary', name: 'aiSummary');
  String get aiAsk => Intl.message('Ask', name: 'aiAsk');
  String get aiSearch => Intl.message('Search', name: 'aiSearch');

  String get settings => Intl.message('Settings', name: 'settings');
  String get language => Intl.message('Language', name: 'language');
  String get theme => Intl.message('Theme', name: 'theme');

  // Add more getters as needed...
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await Intl.defaultLocale = locale.toString();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
