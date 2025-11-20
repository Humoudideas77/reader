import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/subscription_plan.dart';
import '../../data/services/subscription_service.dart';

/// Paywall screen showing subscription plan comparison
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  final MockSubscriptionService _subscriptionService = MockSubscriptionService();
  List<SubscriptionPlan> _plans = [];
  bool _loading = true;
  String _currentPlanId = 'free';

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    try {
      final plans = await _subscriptionService.getAllPlans();
      setState(() {
        _plans = plans;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'اختر خطتك' : 'Choose Your Plan'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Text(
                    isArabic
                        ? 'افتح قوة القراءة الذكية'
                        : 'Unlock the Power of Smart Reading',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isArabic
                        ? 'اختر الخطة المناسبة لاحتياجاتك'
                        : 'Choose the plan that fits your needs',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.gray600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Plan cards
                  ..._ plans.map((plan) => _buildPlanCard(plan, isArabic)),

                  const SizedBox(height: 24),

                  // Comparison table
                  _buildComparisonTable(isArabic),

                  const SizedBox(height: 24),

                  // Footer note
                  Text(
                    isArabic
                        ? '* يمكنك إلغاء اشتراكك في أي وقت. جميع الأسعار شاملة الضرائب.'
                        : '* Cancel anytime. All prices inclusive of tax.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.gray500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan, bool isArabic) {
    final theme = Theme.of(context);
    final isCurrent = plan.id == _currentPlanId;
    final isPopular = plan.isPopular;
    final isBestValue = plan.isBestValue;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: isPopular || isBestValue ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: (isPopular || isBestValue)
              ? const BorderSide(color: AppColors.accentEmeraldGreen, width: 2)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge row
              Row(
                children: [
                  // Plan name
                  Text(
                    isArabic ? plan.nameLocalized : plan.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Badges
                  if (isCurrent)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryInkBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isArabic ? 'الحالية' : 'Current',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.primaryInkBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (isPopular && !isCurrent)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentEmeraldGreen,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isArabic ? 'الأكثر شيوعاً' : 'Popular',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (isBestValue && !isCurrent)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.proBadge,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isArabic ? 'أفضل قيمة' : 'Best Value',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                isArabic ? plan.descriptionLocalized : plan.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.gray600,
                ),
              ),
              const SizedBox(height: 16),

              // Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (plan.monthlyPriceUsd == 0)
                    Text(
                      isArabic ? 'مجاني' : 'Free',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentEmeraldGreen,
                      ),
                    )
                  else ...[
                    Text(
                      '\$${plan.monthlyPriceUsd.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentEmeraldGreen,
                      ),
                    ),
                    Text(
                      isArabic ? '/شهر' : '/month',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ],
              ),
              if (plan.monthlyPriceLocal.isNotEmpty && plan.monthlyPriceUsd > 0)
                Text(
                  '≈ ${plan.monthlyPriceLocal}${isArabic ? '/شهر' : '/month'}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.gray500,
                  ),
                ),
              const SizedBox(height: 20),

              // Features
              ...((isArabic ? plan.featuresLocalized : plan.features))
                  .take(5)
                  .map((feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.accentEmeraldGreen,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                feature,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      )),

              const SizedBox(height: 20),

              // Action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isCurrent ? null : () => _selectPlan(plan),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCurrent
                        ? AppColors.gray300
                        : AppColors.accentEmeraldGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    isCurrent
                        ? (isArabic ? 'الخطة الحالية' : 'Current Plan')
                        : plan.isFree
                            ? (isArabic ? 'متابعة مع المجاني' : 'Continue Free')
                            : plan.isSubscriber
                                ? (isArabic ? 'الترقية' : 'Upgrade')
                                : (isArabic ? 'احصل على Pro' : 'Get Pro'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonTable(bool isArabic) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? 'قارن الميزات' : 'Compare Features',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildComparisonRow(
              isArabic ? 'المستندات' : 'Documents',
              ['5', '100', '1,000'],
              isArabic,
            ),
            _buildComparisonRow(
              isArabic ? 'الصفحات/شهر' : 'Pages/month',
              ['150', '2,000', '10,000'],
              isArabic,
            ),
            _buildComparisonRow(
              isArabic ? 'أسئلة AI/يوم' : 'AI Q&A/day',
              ['10', '50', '200'],
              isArabic,
            ),
            _buildComparisonRow(
              isArabic ? 'التحويلات' : 'Conversions',
              ['5', '100', isArabic ? '∞' : '∞'],
              isArabic,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(String feature, List<String> values, bool isArabic) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              feature,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          ...values.map((value) => Expanded(
                child: Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              )),
        ],
      ),
    );
  }

  void _selectPlan(SubscriptionPlan plan) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    if (plan.isFree) {
      Navigator.pop(context);
      return;
    }

    // TODO: Implement real payment flow
    // For iOS: Use in_app_purchase with StoreKit
    // For Android: Use in_app_purchase with Google Play Billing
    // Or use RevenueCat for unified subscription management

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'قريباً' : 'Coming Soon'),
        content: Text(
          isArabic
              ? 'سيتم دمج الدفع قريباً. سيتم استخدام Stripe أو الشراء داخل التطبيق للاشتراكات.'
              : 'Payment integration coming soon. Will use Stripe or In-App Purchase for subscriptions.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'حسناً' : 'OK'),
          ),
        ],
      ),
    );
  }
}
