/// App-wide constants for Qari2
class AppConstants {
  AppConstants._();

  // App Identity
  static const String appName = 'Qari2';
  static const String appNameArabic = 'قارئ';
  static const String appTaglineEnglish = 'Your smart Arabic document companion.';
  static const String appTaglineArabic = 'رفيقك الذكي لقراءة المستندات';

  // Supported Languages
  static const String languageEnglish = 'en';
  static const String languageArabic = 'ar';

  // File Size Limits (in bytes)
  static const int maxFileSizeBytes = 50 * 1024 * 1024; // 50 MB
  static const int maxFileSizeMB = 50;

  // Supported File Types
  static const List<String> supportedDocumentExtensions = [
    'pdf',
    'doc',
    'docx',
    'txt',
  ];
  static const List<String> supportedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];

  // Animation Durations
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);

  // Pagination
  static const int defaultPageSize = 20;

  // Local Storage Keys
  static const String hiveBoxDocuments = 'documents_box';
  static const String hiveBoxUser = 'user_box';
  static const String hiveBoxSettings = 'settings_box';
  static const String hiveBoxUsage = 'usage_box';

  // Settings Keys
  static const String settingsKeyLanguage = 'language';
  static const String settingsKeyThemeMode = 'theme_mode';
  static const String settingsKeyCurrentPlan = 'current_plan';
  static const String settingsKeyUserProfile = 'user_profile';

  // AI Mock Response Delays (for realistic UX)
  static const Duration aiMockDelayShort = Duration(milliseconds: 800);
  static const Duration aiMockDelayMedium = Duration(milliseconds: 1500);
  static const Duration aiMockDelayLong = Duration(milliseconds: 2500);
}

/// Plan-specific limits and pricing
class PlanLimits {
  PlanLimits._();

  // FREE PLAN
  static const String planIdFree = 'free';
  static const int freeMaxDocuments = 5;
  static const int freePagesPerMonth = 150;
  static const int freeAiQuestionsPerDay = 10;
  static const int freeConversionsPerMonth = 5;
  static const double freePriceUsd = 0.0;
  static const String freePriceLocal = '0';

  // SUBSCRIBER PLAN
  static const String planIdSubscriber = 'subscriber';
  static const int subscriberMaxDocuments = 100;
  static const int subscriberPagesPerMonth = 2000;
  static const int subscriberAiQuestionsPerDay = 50;
  static const int subscriberConversionsPerMonth = 100;
  static const double subscriberPriceUsd = 6.99;
  static const String subscriberPriceLocal = '2.25 KWD'; // Example local currency

  // PRO PLAN
  static const String planIdPro = 'pro';
  static const int proMaxDocuments = 1000;
  static const int proPagesPerMonth = 10000;
  static const int proAiQuestionsPerDay = 200;
  static const int proConversionsPerMonth = -1; // Unlimited
  static const double proPriceUsd = 12.99;
  static const String proPriceLocal = '4.0 KWD';
}
