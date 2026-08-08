import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/i18n/app_strings.dart';
import '../../state/register_provider.dart';
import 'feedback_modal.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _showFeedbackModal(BuildContext context) {
    Navigator.of(context).pop(); // Close drawer
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const FeedbackModal(),
    );
  }

  void _confirmClearSampleData(BuildContext context, RegisterProvider provider) {
    final strings = provider.strings;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgParchment,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          strings.clearSampleData,
          style: const TextStyle(
            fontFamily: 'serif',
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        content: Text(
          strings.isHindi
              ? 'क्या आप सभी रजिस्टर डाटा साफ़ करना चाहते हैं?'
              : 'Do you want to clear all register data?',
          style: const TextStyle(fontSize: 13, color: AppColors.textDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(strings.cancel, style: const TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.stampABorder,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              provider.clearAllSampleData();
              Navigator.of(ctx).pop(); // Close dialog
              Navigator.of(context).pop(); // Close drawer
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(strings.sampleDataCleared),
                  backgroundColor: AppColors.navyLedger,
                ),
              );
            },
            child: Text(
              strings.isHindi ? 'हाँ, साफ़ करें' : 'Yes, Clear',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = RegisterProviderScope.of(context);
    final strings = provider.strings;
    final isHindi = provider.language == AppLanguage.hindi;

    return Drawer(
      backgroundColor: AppColors.bgParchment,
      child: Column(
        children: [
          // Drawer Top Header
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.navyLedger,
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.goldAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'ख',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyLedger,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.drawerTitle,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        strings.drawerSub,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Menu List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                // Language Selection Section
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderCard),
                  ),
                  child: ExpansionTile(
                    leading: const Icon(Icons.language, color: AppColors.navyLedger),
                    title: Text(
                      strings.selectLanguage,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    subtitle: Text(
                      isHindi ? 'हिन्दी (Hindi) सक्रिय है' : 'English is Active',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    children: [
                      RadioListTile<AppLanguage>(
                        value: AppLanguage.hindi,
                        groupValue: provider.language,
                        title: const Text('हिन्दी (Hindi)'),
                        activeColor: AppColors.navyLedger,
                        onChanged: (val) {
                          if (val != null) provider.setLanguage(val);
                        },
                      ),
                      RadioListTile<AppLanguage>(
                        value: AppLanguage.english,
                        groupValue: provider.language,
                        title: const Text('English'),
                        activeColor: AppColors.navyLedger,
                        onChanged: (val) {
                          if (val != null) provider.setLanguage(val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Feedback & Suggestion Tile
                ListTile(
                  leading: const Icon(Icons.rate_review_outlined, color: AppColors.navyLedger),
                  title: Text(
                    strings.feedbackAndWishlist,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.textMuted),
                  tileColor: AppColors.bgCard,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AppColors.borderCard),
                  ),
                  onTap: () => _showFeedbackModal(context),
                ),
                const SizedBox(height: 12),

                // Load Demo Data Tile (Optional test helper)
                ListTile(
                  leading: const Icon(Icons.dataset_outlined, color: AppColors.navyLedger),
                  title: Text(
                    isHindi ? 'डेमो (Demo) डाटा लोड करें' : 'Load Demo Data',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  tileColor: AppColors.bgCard,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AppColors.borderCard),
                  ),
                  onTap: () {
                    provider.loadSampleDemoData();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isHindi ? 'डेमो डाटा लोड हो गया' : 'Demo data loaded'),
                        backgroundColor: AppColors.navyLedger,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Clear Register Data Tile
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: AppColors.stampABorder),
                  title: Text(
                    strings.clearSampleData,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.stampABorder,
                    ),
                  ),
                  tileColor: AppColors.bgCard,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AppColors.borderCard),
                  ),
                  onTap: () => _confirmClearSampleData(context, provider),
                ),
              ],
            ),
          ),

          // Drawer Bottom Version Tag
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Divider(color: AppColors.borderCard),
                const SizedBox(height: 8),
                Text(
                  strings.appVersion,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
