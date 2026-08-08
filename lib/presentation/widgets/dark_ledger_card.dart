import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class DarkLedgerCard extends StatelessWidget {
  final double earned;
  final double paid;
  final double advance;
  final double due;
  final String earnedLabel;
  final String paidLabel;
  final String advanceLabel;
  final String balanceDueLabel;
  final String recordPaymentLabel;
  final String giveAdvanceLabel;
  final VoidCallback? onRecordPayment;
  final VoidCallback? onGiveAdvance;

  const DarkLedgerCard({
    super.key,
    required this.earned,
    required this.paid,
    required this.advance,
    required this.due,
    this.earnedLabel = 'Earned',
    this.paidLabel = 'Paid',
    this.advanceLabel = 'Advance',
    this.balanceDueLabel = 'Balance due',
    this.recordPaymentLabel = 'Record Payment',
    this.giveAdvanceLabel = 'Give Advance',
    this.onRecordPayment,
    this.onGiveAdvance,
  });

  String _formatCurrency(double amount) {
    final intVal = amount.round();
    final str = intVal.toString();
    if (str.length > 3) {
      final lastThree = str.substring(str.length - 3);
      final otherNumbers = str.substring(0, str.length - 3);
      final formatted = otherNumbers.replaceAllMapped(
          RegExp(r'(\d+?)(?=(\d{2})+(?!\d))'), (Match m) => '${m[1]},');
      return '₹$formatted$lastThree';
    }
    return '₹$str';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navyLedger,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.navyLedgerBorder, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x331A2634),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtle Gold Accent Bar at Top
          Container(
            height: 3,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              gradient: LinearGradient(
                colors: [Color(0xFFE59836), Color(0xFFF3C474), Color(0xFFE59836)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Earned / Paid / Advance
                Row(
                  children: [
                    Expanded(
                      child: _LedgerItem(
                        title: earnedLabel,
                        amount: _formatCurrency(earned),
                      ),
                    ),
                    Expanded(
                      child: _LedgerItem(
                        title: paidLabel,
                        amount: _formatCurrency(paid),
                      ),
                    ),
                    Expanded(
                      child: _LedgerItem(
                        title: advanceLabel,
                        amount: _formatCurrency(advance),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(color: Colors.white12, height: 1),
                const SizedBox(height: 14),
                // Bottom Row: Balance Due
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      balanceDueLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFCBD5E1),
                      ),
                    ),
                    Text(
                      _formatCurrency(due),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.goldAccent,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                // Quick Action Buttons
                if (onRecordPayment != null || onGiveAdvance != null) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      if (onRecordPayment != null)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onRecordPayment,
                            icon: const Icon(Icons.add, size: 14, color: Colors.white),
                            label: Text(
                              recordPaymentLabel,
                              style: const TextStyle(fontSize: 11, color: Colors.white),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white.withAlpha(51)),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      if (onRecordPayment != null && onGiveAdvance != null)
                        const SizedBox(width: 8),
                      if (onGiveAdvance != null)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onGiveAdvance,
                            icon: const Icon(Icons.payment, size: 14, color: AppColors.goldAccent),
                            label: Text(
                              giveAdvanceLabel,
                              style: const TextStyle(fontSize: 11, color: AppColors.goldAccent),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.goldAccent.withAlpha(102)),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LedgerItem extends StatelessWidget {
  final String title;
  final String amount;

  const _LedgerItem({
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            amount,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF8FAFC),
              letterSpacing: -0.3,
            ),
          ),
        ),
      ],
    );
  }
}
