import 'package:flutter/material.dart';
import 'package:runnerp/core/i18n/app_strings.dart';
import '../../core/constants/app_colors.dart';
import '../../state/register_provider.dart';

class SubscriptionModal extends StatefulWidget {
  const SubscriptionModal({super.key});

  @override
  State<SubscriptionModal> createState() => _SubscriptionModalState();
}

class _SubscriptionModalState extends State<SubscriptionModal> {
  int _selectedPlanIndex = 1; // Default Yearly 60% OFF

  void _processUpgrade() {
    final provider = RegisterProviderScope.of(context);
    provider.upgradeToPro();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.stars, color: AppColors.goldAccent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                provider.strings.isHindi
                    ? 'बधाई हो! आपका खाता PRO सफलतापूर्वक चालू हो गया है! 👑'
                    : 'Congratulations! Khata PRO activated successfully! 👑',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.navyLedger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = RegisterProviderScope.of(context);
    final isHindi = provider.language == AppLanguage.hindi;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: AppColors.bgParchment,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close & Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.goldAccent.withAlpha(50),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.workspace_premium,
                          color: AppColors.goldAccent, size: 24),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isHindi ? 'खाता PRO अपग्रेड' : 'Upgrade to Khata PRO',
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMuted),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // PRO Features Checklist
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderCard),
              ),
              child: Column(
                children: [
                  _FeatureRow(
                    icon: Icons.block,
                    title: isHindi ? '100% विज्ञापन-मुक्त अनुभव (No Ads)' : '100% Ad-Free Experience',
                  ),
                  const SizedBox(height: 10),
                  _FeatureRow(
                    icon: Icons.groups,
                    title: isHindi ? 'अनलिमिटेड मज़दूर एंट्री (Unlimited Workers)' : 'Unlimited Workers Entry',
                  ),
                  const SizedBox(height: 10),
                  _FeatureRow(
                    icon: Icons.picture_as_pdf,
                    title: isHindi ? 'WhatsApp ऑटो PDF सैलरी स्लिप' : 'Auto WhatsApp PDF Salary Slips',
                  ),
                  const SizedBox(height: 10),
                  _FeatureRow(
                    icon: Icons.cloud_done,
                    title: isHindi ? '24x7 ऑटोमेटिक क्लाउड बैकअप' : '24x7 Automatic Cloud Backup',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Plan Select Cards
            Text(
              isHindi ? 'अपना प्लान चुनें:' : 'Select Your Plan:',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 10),

            // Monthly Plan Card
            _PlanCard(
              title: isHindi ? 'मंथली प्लान (Monthly)' : 'Monthly Plan',
              price: '₹199 / month',
              badge: isHindi ? 'महीने का सब्सक्रिप्शन' : 'Monthly Subscription',
              isSelected: _selectedPlanIndex == 0,
              onTap: () => setState(() => _selectedPlanIndex = 0),
            ),
            const SizedBox(height: 10),

            // Yearly Plan Card (Best Value)
            _PlanCard(
              title: isHindi ? 'इयरली प्लान (Yearly)' : 'Yearly Plan',
              price: '₹999 / year',
              badge: isHindi ? '🔥 60% बचत (Best Value)' : '🔥 SAVE 60% (Best Value)',
              isHighlight: true,
              isSelected: _selectedPlanIndex == 1,
              onTap: () => setState(() => _selectedPlanIndex = 1),
            ),
            const SizedBox(height: 24),

            // Upgrade Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _processUpgrade,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navyLedger,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.workspace_premium, color: AppColors.goldAccent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      isHindi ? 'अभी PRO चालू करें (Demo Paywall) ➔' : 'Activate PRO Now (Demo) ➔',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;

  const _FeatureRow({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.navyLedger),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String badge;
  final bool isSelected;
  final bool isHighlight;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.badge,
    required this.isSelected,
    this.isHighlight = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.bgCard : const Color(0x77FFFDF7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.navyLedger : AppColors.borderCard,
            width: isSelected ? 2.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  badge,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isHighlight ? const Color(0xFFC25B12) : AppColors.textMuted,
                  ),
                ),
              ],
            ),
            Text(
              price,
              style: const TextStyle(
                fontFamily: 'serif',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
