import '../../core/constants/app_constants.dart';
import '../../domain/entities/subscription_plan.dart';
import '../../domain/entities/usage_stats.dart';
import '../../domain/entities/user.dart';

/// Result of a limit check
class LimitCheckResult {
  final bool allowed;
  final String? errorMessage;
  final int? currentUsage;
  final int? limit;

  const LimitCheckResult({
    required this.allowed,
    this.errorMessage,
    this.currentUsage,
    this.limit,
  });

  factory LimitCheckResult.allowed() {
    return const LimitCheckResult(allowed: true);
  }

  factory LimitCheckResult.denied({
    required String errorMessage,
    int? currentUsage,
    int? limit,
  }) {
    return LimitCheckResult(
      allowed: false,
      errorMessage: errorMessage,
      currentUsage: currentUsage,
      limit: limit,
    );
  }
}

/// Abstract interface for Subscription Service
/// Manages user plans, limits, and billing
abstract class SubscriptionService {
  Future<SubscriptionPlan> getCurrentPlan(String userId);
  Future<List<SubscriptionPlan>> getAllPlans();
  Future<void> upgradeToPlan(String userId, String planId);
  Future<UsageStats> getUsageStats(String userId);
  Future<LimitCheckResult> canImportDocument(User user, UsageStats usage);
  Future<LimitCheckResult> canProcessPages(User user, UsageStats usage, int pageCount);
  Future<LimitCheckResult> canAskAiQuestion(User user, UsageStats usage);
  Future<LimitCheckResult> canUseConversion(User user, UsageStats usage);
}

/// Mock implementation of SubscriptionService
/// TODO: Replace with real backend API and payment gateway integration
/// Real implementation should integrate:
/// - Payment gateway (Stripe, Apple Pay, Google Pay)
/// - Subscription management (recurring billing)
/// - Usage tracking and enforcement
/// - Webhook handling for subscription events
class MockSubscriptionService implements SubscriptionService {
  // Mock in-memory storage (would be backend database in real app)
  final Map<String, String> _userPlans = {}; // userId -> planId
  final Map<String, UsageStats> _userUsage = {}; // userId -> stats

  @override
  Future<SubscriptionPlan> getCurrentPlan(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final planId = _userPlans[userId] ?? PlanLimits.planIdFree;
    final allPlans = await getAllPlans();

    return allPlans.firstWhere((plan) => plan.id == planId);
  }

  @override
  Future<List<SubscriptionPlan>> getAllPlans() async {
    await Future.delayed(const Duration(milliseconds: 200));

    // TODO: Fetch from backend API
    // Example endpoint: GET /api/v1/subscription/plans

    return [
      _getFreePlan(),
      _getSubscriberPlan(),
      _getProPlan(),
    ];
  }

  @override
  Future<void> upgradeToPlan(String userId, String planId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // TODO: Implement real payment flow
    // Steps:
    // 1. Validate plan exists
    // 2. If paid plan:
    //    - Initiate payment via Stripe/IAP
    //    - Handle payment confirmation
    //    - Webhook: Update subscription status
    // 3. Update user's plan in backend
    // 4. Sync local state
    //
    // For mobile payments:
    // - iOS: Use in_app_purchase package with StoreKit
    // - Android: Use in_app_purchase with Google Play Billing
    // - Consider revenue_cat for unified subscription management

    _userPlans[userId] = planId;
  }

  @override
  Future<UsageStats> getUsageStats(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // TODO: Fetch from backend API
    // Example endpoint: GET /api/v1/usage/stats?userId={userId}

    if (!_userUsage.containsKey(userId)) {
      _userUsage[userId] = UsageStats(
        userId: userId,
        month: _getCurrentMonth(),
        pagesProcessed: 0,
        aiQuestionsAskedToday: 0,
        documentsImported: 0,
        conversionsUsed: 0,
        lastResetDate: DateTime.now(),
      );
    }

    return _userUsage[userId]!.resetIfNewDay();
  }

  @override
  Future<LimitCheckResult> canImportDocument(User user, UsageStats usage) async {
    final plan = await getCurrentPlan(user.id);

    if (usage.documentsImported >= plan.maxDocuments) {
      return LimitCheckResult.denied(
        errorMessage: 'Document limit reached for ${plan.name} plan',
        currentUsage: usage.documentsImported,
        limit: plan.maxDocuments,
      );
    }

    return LimitCheckResult.allowed();
  }

  @override
  Future<LimitCheckResult> canProcessPages(
    User user,
    UsageStats usage,
    int pageCount,
  ) async {
    final plan = await getCurrentPlan(user.id);

    if (usage.pagesProcessed + pageCount > plan.maxPagesPerMonth) {
      return LimitCheckResult.denied(
        errorMessage: 'Monthly page limit reached for ${plan.name} plan',
        currentUsage: usage.pagesProcessed,
        limit: plan.maxPagesPerMonth,
      );
    }

    return LimitCheckResult.allowed();
  }

  @override
  Future<LimitCheckResult> canAskAiQuestion(User user, UsageStats usage) async {
    final plan = await getCurrentPlan(user.id);
    final updatedUsage = usage.resetIfNewDay();

    if (updatedUsage.aiQuestionsAskedToday >= plan.maxAiQuestionsPerDay) {
      return LimitCheckResult.denied(
        errorMessage: 'Daily AI question limit reached for ${plan.name} plan',
        currentUsage: updatedUsage.aiQuestionsAskedToday,
        limit: plan.maxAiQuestionsPerDay,
      );
    }

    return LimitCheckResult.allowed();
  }

  @override
  Future<LimitCheckResult> canUseConversion(User user, UsageStats usage) async {
    final plan = await getCurrentPlan(user.id);

    if (plan.maxConversionsPerMonth == -1) {
      return LimitCheckResult.allowed(); // Unlimited
    }

    if (usage.conversionsUsed >= plan.maxConversionsPerMonth) {
      return LimitCheckResult.denied(
        errorMessage: 'Monthly conversion limit reached for ${plan.name} plan',
        currentUsage: usage.conversionsUsed,
        limit: plan.maxConversionsPerMonth,
      );
    }

    return LimitCheckResult.allowed();
  }

  // --- Plan Definitions ---

  SubscriptionPlan _getFreePlan() {
    return const SubscriptionPlan(
      id: PlanLimits.planIdFree,
      name: 'Free',
      nameLocalized: 'مجاني',
      description: 'Get started with basic features',
      descriptionLocalized: 'ابدأ مع الميزات الأساسية',
      monthlyPriceUsd: PlanLimits.freePriceUsd,
      monthlyPriceLocal: PlanLimits.freePriceLocal,
      maxDocuments: PlanLimits.freeMaxDocuments,
      maxPagesPerMonth: PlanLimits.freePagesPerMonth,
      maxAiQuestionsPerDay: PlanLimits.freeAiQuestionsPerDay,
      maxConversionsPerMonth: PlanLimits.freeConversionsPerMonth,
      features: [
        '5 documents',
        '150 pages/month',
        '10 AI questions/day',
        '5 conversions/month',
        'Basic summaries',
      ],
      featuresLocalized: [
        '5 مستندات',
        '150 صفحة/شهر',
        '10 أسئلة ذكية/يوم',
        '5 تحويلات/شهر',
        'ملخصات أساسية',
      ],
    );
  }

  SubscriptionPlan _getSubscriberPlan() {
    return const SubscriptionPlan(
      id: PlanLimits.planIdSubscriber,
      name: 'Subscriber',
      nameLocalized: 'مشترك',
      description: 'Perfect for students and regular users',
      descriptionLocalized: 'مثالي للطلاب والمستخدمين المنتظمين',
      monthlyPriceUsd: PlanLimits.subscriberPriceUsd,
      monthlyPriceLocal: PlanLimits.subscriberPriceLocal,
      maxDocuments: PlanLimits.subscriberMaxDocuments,
      maxPagesPerMonth: PlanLimits.subscriberPagesPerMonth,
      maxAiQuestionsPerDay: PlanLimits.subscriberAiQuestionsPerDay,
      maxConversionsPerMonth: PlanLimits.subscriberConversionsPerMonth,
      features: [
        '100 documents',
        '2,000 pages/month',
        '50 AI questions/day',
        '100 conversions/month',
        'All summary modes',
        'Priority AI queue',
        'No ads',
        'Multi-document chat',
      ],
      featuresLocalized: [
        '100 مستند',
        '2,000 صفحة/شهر',
        '50 سؤال ذكي/يوم',
        '100 تحويل/شهر',
        'جميع أوضاع الملخصات',
        'أولوية في الذكاء الاصطناعي',
        'بدون إعلانات',
        'محادثة متعددة المستندات',
      ],
      isPopular: true,
    );
  }

  SubscriptionPlan _getProPlan() {
    return const SubscriptionPlan(
      id: PlanLimits.planIdPro,
      name: 'Pro',
      nameLocalized: 'Pro',
      description: 'For power users and professionals',
      descriptionLocalized: 'للمستخدمين المحترفين والمتقدمين',
      monthlyPriceUsd: PlanLimits.proPriceUsd,
      monthlyPriceLocal: PlanLimits.proPriceLocal,
      maxDocuments: PlanLimits.proMaxDocuments,
      maxPagesPerMonth: PlanLimits.proPagesPerMonth,
      maxAiQuestionsPerDay: PlanLimits.proAiQuestionsPerDay,
      maxConversionsPerMonth: PlanLimits.proConversionsPerMonth,
      features: [
        '1,000 documents',
        '10,000 pages/month',
        '200 AI questions/day',
        'Unlimited conversions',
        'All Subscriber features',
        'Advanced AI tools',
        'Auto-outline generator',
        'Study flashcards',
        'Priority support',
      ],
      featuresLocalized: [
        '1,000 مستند',
        '10,000 صفحة/شهر',
        '200 سؤال ذكي/يوم',
        'تحويلات غير محدودة',
        'جميع ميزات المشترك',
        'أدوات ذكاء اصطناعي متقدمة',
        'مولد المخطط التلقائي',
        'بطاقات الدراسة',
        'دعم ذو أولوية',
      ],
      isBestValue: true,
    );
  }

  String _getCurrentMonth() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }
}
