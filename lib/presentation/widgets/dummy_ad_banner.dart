import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../state/register_provider.dart';
import 'subscription_modal.dart';

class DummyAdBannerWidget extends StatelessWidget {
  const DummyAdBannerWidget({super.key});

  void _openSubscriptionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const SubscriptionModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = RegisterProviderScope.of(context);

    // If user has upgraded to PRO, hide all Ads!
    if (provider.isProUser) {
      return const SizedBox.shrink();
    }

    final isHindi = provider.strings.isHindi;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ad Badge Icon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.goldAccent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'AD',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.navyLedger,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Sponsor Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isHindi ? 'जिंदल TMT स्टील · डेमो स्पॉन्सर विज्ञापन' : 'Jindal TMT Steel · Demo Sponsor Ad',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  isHindi ? 'निर्माण कार्य हेतु भारी छूट पर सरिया प्राप्त करें' : 'Get TMT steel bars for construction',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Remove Ads / Upgrade Button
          InkWell(
            onTap: () => _openSubscriptionModal(context),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.navyLedger,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.workspace_premium,
                      color: AppColors.goldAccent, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    isHindi ? 'हटाएं' : 'Remove',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
