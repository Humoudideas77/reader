import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routing/app_router.dart';

/// Settings screen for app configuration
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'en';
  ThemeMode _themeMode = ThemeMode.system;
  String _currentPlan = 'free';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'الإعدادات' : 'Settings'),
      ),
      body: ListView(
        children: [
          // Account Section
          _buildSectionHeader(
            context,
            isArabic ? 'الحساب' : 'Account',
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.primaryInkBlue,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: const Text('Guest User'),
            subtitle: Text(isArabic ? 'غير مسجل الدخول' : 'Not signed in'),
            trailing: TextButton(
              onPressed: () {
                // TODO: Show sign in/sign up
                _showComingSoon(isArabic);
              },
              child: Text(isArabic ? 'تسجيل الدخول' : 'Sign In'),
            ),
          ),
          const Divider(),

          // Subscription Section
          _buildSectionHeader(
            context,
            isArabic ? 'الاشتراك' : 'Subscription',
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accentEmeraldGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.workspace_premium,
                color: AppColors.accentEmeraldGreen,
              ),
            ),
            title: Text(isArabic ? 'الخطة الحالية' : 'Current Plan'),
            subtitle: Text(
              _getPlanName(_currentPlan, isArabic),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRouter.paywall),
          ),
          const Divider(),

          // Language Section
          _buildSectionHeader(
            context,
            isArabic ? 'اللغة' : 'Language',
          ),
          RadioListTile<String>(
            title: const Text('English'),
            value: 'en',
            groupValue: _selectedLanguage,
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
              // TODO: Update app language
              _showComingSoon(isArabic);
            },
          ),
          RadioListTile<String>(
            title: const Text('العربية'),
            value: 'ar',
            groupValue: _selectedLanguage,
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
              // TODO: Update app language
              _showComingSoon(isArabic);
            },
          ),
          const Divider(),

          // Appearance Section
          _buildSectionHeader(
            context,
            isArabic ? 'المظهر' : 'Appearance',
          ),
          RadioListTile<ThemeMode>(
            title: Text(isArabic ? 'فاتح' : 'Light'),
            value: ThemeMode.light,
            groupValue: _themeMode,
            onChanged: (value) {
              setState(() {
                _themeMode = value!;
              });
              // TODO: Update theme
              _showComingSoon(isArabic);
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text(isArabic ? 'داكن' : 'Dark'),
            value: ThemeMode.dark,
            groupValue: _themeMode,
            onChanged: (value) {
              setState(() {
                _themeMode = value!;
              });
              // TODO: Update theme
              _showComingSoon(isArabic);
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text(isArabic ? 'النظام' : 'System'),
            value: ThemeMode.system,
            groupValue: _themeMode,
            onChanged: (value) {
              setState(() {
                _themeMode = value!;
              });
              // TODO: Update theme
              _showComingSoon(isArabic);
            },
          ),
          const Divider(),

          // Document Defaults Section
          _buildSectionHeader(
            context,
            isArabic ? 'إعدادات المستندات' : 'Document Settings',
          ),
          SwitchListTile(
            title: Text(isArabic ? 'فتح في الوضع الداكن' : 'Open in Dark Mode'),
            subtitle: Text(
              isArabic
                  ? 'تطبيق الوضع الداكن عند فتح المستندات'
                  : 'Apply dark mode when opening documents',
            ),
            value: false,
            onChanged: (value) {
              // TODO: Save preference
              _showComingSoon(isArabic);
            },
          ),
          SwitchListTile(
            title: Text(isArabic ? 'التمرير المستمر' : 'Continuous Scroll'),
            subtitle: Text(
              isArabic
                  ? 'التمرير بشكل مستمر بين الصفحات'
                  : 'Scroll continuously between pages',
            ),
            value: true,
            onChanged: (value) {
              // TODO: Save preference
              _showComingSoon(isArabic);
            },
          ),
          const Divider(),

          // AI Settings Section
          _buildSectionHeader(
            context,
            isArabic ? 'إعدادات AI' : 'AI Settings',
          ),
          ListTile(
            title: Text(isArabic ? 'الملخص الافتراضي' : 'Default Summary Mode'),
            subtitle: Text(isArabic ? 'قصير' : 'Short'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show summary mode picker
              _showComingSoon(isArabic);
            },
          ),
          ListTile(
            title: Text(isArabic ? 'لغة الإجابات' : 'Response Language'),
            subtitle: Text(isArabic ? 'تلقائي' : 'Auto'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show language picker
              _showComingSoon(isArabic);
            },
          ),
          const Divider(),

          // About Section
          _buildSectionHeader(
            context,
            isArabic ? 'حول' : 'About',
          ),
          ListTile(
            title: Text(isArabic ? 'الإصدار' : 'Version'),
            subtitle: const Text('1.0.0 (Build 1)'),
          ),
          ListTile(
            title: Text(isArabic ? 'شروط الخدمة' : 'Terms of Service'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () {
              // TODO: Open terms
              _showComingSoon(isArabic);
            },
          ),
          ListTile(
            title: Text(isArabic ? 'سياسة الخصوصية' : 'Privacy Policy'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () {
              // TODO: Open privacy policy
              _showComingSoon(isArabic);
            },
          ),
          ListTile(
            title: Text(isArabic ? 'اتصل بنا' : 'Contact Us'),
            trailing: const Icon(Icons.email),
            onTap: () {
              // TODO: Open email
              _showComingSoon(isArabic);
            },
          ),

          const SizedBox(height: 32),

          // App branding
          Center(
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.accentEmeraldGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.auto_stories,
                    size: 32,
                    color: AppColors.accentEmeraldGreen,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Qari2 | قارئ',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isArabic
                      ? 'رفيقك الذكي لقراءة المستندات'
                      : 'Your smart Arabic document companion',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.gray600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.accentEmeraldGreen,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  String _getPlanName(String planId, bool isArabic) {
    switch (planId) {
      case 'free':
        return isArabic ? 'مجاني' : 'Free';
      case 'subscriber':
        return isArabic ? 'مشترك' : 'Subscriber';
      case 'pro':
        return 'Pro';
      default:
        return planId;
    }
  }

  void _showComingSoon(bool isArabic) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isArabic ? 'هذه الميزة قيد التطوير' : 'This feature is coming soon',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
