import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/i18n/app_strings.dart';
import '../../core/services/auth_service.dart';
import '../../presentation/screens/google_auth_screen.dart';
import '../../state/register_provider.dart';
import 'feedback_modal.dart';
import 'subscription_modal.dart';

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

  void _handleSignOut(BuildContext context) async {
    final authService = AuthService();
    await authService.signOut();
    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx) => const GoogleAuthScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = RegisterProviderScope.of(context);
    final strings = provider.strings;
    final isHindi = provider.language == AppLanguage.hindi;
    final authService = AuthService();
    final user = authService.currentUser;

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
                if (user?.photoURL != null) ...[
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(user!.photoURL!),
                  ),
                ] else ...[
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
                ],
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.ownerName.isNotEmpty
                            ? provider.ownerName
                            : (user?.displayName ?? strings.drawerTitle),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        provider.businessName.isNotEmpty
                            ? '${provider.businessName} · ${user?.email ?? ""}'
                            : (user?.email ?? strings.drawerSub),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
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

                // Upgrade to PRO / Premium Status Tile
                ListTile(
                  leading: const Icon(Icons.workspace_premium, color: AppColors.goldAccent),
                  title: Text(
                    provider.isProUser
                        ? (isHindi ? '👑 खाता PRO (एक्टिव)' : '👑 Khata PRO (Active)')
                        : (isHindi ? '👑 PRO में अपग्रेड करें' : '👑 Upgrade to PRO'),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: provider.isProUser ? AppColors.navyLedger : const Color(0xFFC25B12),
                    ),
                  ),
                  subtitle: Text(
                    provider.isProUser
                        ? (isHindi ? 'विज्ञापन-मुक्त & क्लाउड बैकअप' : 'Ad-Free & Cloud Backup')
                        : (isHindi ? 'विज्ञापन हटाएं & WhatsApp PDF पाएँ' : 'Remove Ads & PDF Slips'),
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                  trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.textMuted),
                  tileColor: AppColors.bgCard,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                        color: provider.isProUser ? AppColors.goldAccent : AppColors.borderCard),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => const SubscriptionModal(),
                    );
                  },
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

                // Offline Mode Test Switch Tile
                SwitchListTile(
                  secondary: const Icon(Icons.wifi_off_outlined, color: AppColors.navyLedger),
                  title: Text(
                    isHindi ? 'ऑफ़लाइन मोड (Offline Mode)' : 'Offline Mode Sync',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  subtitle: Text(
                    isHindi ? 'बिना इंटरनेट के काम करें' : 'Work without internet',
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                  value: provider.isOffline,
                  activeColor: AppColors.navyLedger,
                  tileColor: AppColors.bgCard,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AppColors.borderCard),
                  ),
                  onChanged: (val) {
                    provider.toggleOfflineMode(val);
                  },
                ),
                const SizedBox(height: 12),

                // Sign Out Tile
                ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.stampABorder),
                  title: Text(
                    isHindi ? 'साइन आउट (लॉगआउट)' : 'Sign Out',
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
                  onTap: () => _handleSignOut(context),
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
