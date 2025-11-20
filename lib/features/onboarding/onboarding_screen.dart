import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routing/app_router.dart';

/// Onboarding screen with swipeable slides
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = [
    const OnboardingSlide(
      icon: Icons.menu_book,
      titleEn: 'Read and understand any document',
      titleAr: 'اقرأ وافهم أي مستند',
      subtitleEn: 'Import PDFs and scans in Arabic & English',
      subtitleAr: 'استيراد ملفات PDF والمسح الضوئي بالعربية والإنجليزية',
    ),
    const OnboardingSlide(
      icon: Icons.chat_bubble_outline,
      titleEn: 'Ask questions instead of scrolling',
      titleAr: 'اسأل الأسئلة بدل التمرير',
      subtitleEn: 'Semantic search, summaries, and AI Q&A',
      subtitleAr: 'بحث دلالي، ملخصات، وأسئلة وأجوبة ذكية',
    ),
    const OnboardingSlide(
      icon: Icons.speed,
      titleEn: 'Study and work faster on the go',
      titleAr: 'ادرس واعمل بشكل أسرع',
      subtitleEn: 'Your documents, always with you on mobile',
      subtitleAr: 'مستنداتك معك دائماً على الهاتف',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    // TODO: Save onboarding completion status
    context.go(AppRouter.library);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: isArabic ? Alignment.topLeft : Alignment.topRight,
              child: TextButton(
                onPressed: _finishOnboarding,
                child: Text(
                  isArabic ? 'تخطي' : 'Skip',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return _buildSlide(context, _slides[index], isArabic);
                },
              ),
            ),

            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => _buildDot(index == _currentPage),
                ),
              ),
            ),

            // Next/Get Started button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _currentPage == _slides.length - 1
                        ? (isArabic ? 'ابدأ الآن' : 'Get Started')
                        : (isArabic ? 'التالي' : 'Next'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(BuildContext context, OnboardingSlide slide, bool isArabic) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.accentEmeraldGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              slide.icon,
              size: 80,
              color: AppColors.accentEmeraldGreen,
            ),
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            isArabic ? slide.titleAr : slide.titleEn,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Subtitle
          Text(
            isArabic ? slide.subtitleAr : slide.subtitleEn,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.accentEmeraldGreen
            : AppColors.gray300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingSlide {
  final IconData icon;
  final String titleEn;
  final String titleAr;
  final String subtitleEn;
  final String subtitleAr;

  const OnboardingSlide({
    required this.icon,
    required this.titleEn,
    required this.titleAr,
    required this.subtitleEn,
    required this.subtitleAr,
  });
}
