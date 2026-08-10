import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../state/register_provider.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String employeeId;
  final String employeeName;

  const DeleteConfirmationDialog({
    super.key,
    required this.employeeId,
    required this.employeeName,
  });

  @override
  Widget build(BuildContext context) {
    final provider = RegisterProviderScope.of(context);
    final isHindi = provider.strings.isHindi;

    return Dialog(
      backgroundColor: AppColors.bgParchment,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.stampABorder, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Red Warning Stamp Icon Badge
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEB),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.stampABorder, width: 2),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.delete_forever,
                color: AppColors.stampABorder,
                size: 32,
              ),
            ),
            const SizedBox(height: 18),

            // Title
            Text(
              isHindi ? 'मज़दूर हटाएं?' : 'Delete Worker?',
              style: const TextStyle(
                fontFamily: 'serif',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle Warning Message
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: isHindi
                        ? 'क्या आप सचमुच '
                        : 'Are you sure you want to permanently delete ',
                  ),
                  TextSpan(
                    text: employeeName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  TextSpan(
                    text: isHindi
                        ? ' को रजिस्टर से permanently हटाना चाहते हैं? इनका पूरा हाज़िरी व हिसाब रिकॉर्ड क्लाउड से भी हट जाएगा।'
                        : ' from your register? All attendance and payment records will be permanently removed from cloud database.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons Row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.borderCard),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      isHindi ? 'रद्द करें' : 'Cancel',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      provider.deleteEmployee(employeeId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.stampABorder,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      isHindi ? 'हाँ, हटाएं' : 'Yes, Delete',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
