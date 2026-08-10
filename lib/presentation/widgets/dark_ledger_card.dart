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
        gradient: const LinearGradient(
          colors: [Color(0xFF1A2634), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x33F3C474), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x351A2634),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Financial Metric Grid: Earned / Paid / Advance
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0x0FFFFFFF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x1AFFFFFF)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _LedgerMetricItem(
                    title: earnedLabel,
                    amount: _formatCurrency(earned),
                    color: Colors.white,
                  ),
                ),
                Container(height: 28, width: 1, color: const Color(0x22FFFFFF)),
                Expanded(
                  child: _LedgerMetricItem(
                    title: paidLabel,
                    amount: _formatCurrency(paid),
                    color: const Color(0xFF6EE7B7), // Soft Emerald Green
                  ),
                ),
                Container(height: 28, width: 1, color: const Color(0x22FFFFFF)),
                Expanded(
                  child: _LedgerMetricItem(
                    title: advanceLabel,
                    amount: _formatCurrency(advance),
                    color: const Color(0xFFFDE047), // Soft Amber Gold
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Main Balance Due Card Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.stampABorder,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        balanceDueLabel.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatCurrency(due),
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: due > 0 ? const Color(0xFFFCA5A5) : Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              // Pro Gold Badge Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0x22F3C474),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.goldAccent.withAlpha(100)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.workspace_premium,
                        size: 14, color: AppColors.goldAccent),
                    SizedBox(width: 4),
                    Text(
                      'KHATA LEDGER',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.goldAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Bottom Interactive Action Buttons: Record Payment & Give Advance
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onRecordPayment,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E), // Vibrant Green Button
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3322C55E),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_card, size: 16, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          recordPaymentLabel,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: onGiveAdvance,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0x22FFFFFF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0x44FFFFFF)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.payments_outlined,
                            size: 16, color: AppColors.goldAccent),
                        const SizedBox(width: 6),
                        Text(
                          giveAdvanceLabel,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LedgerMetricItem extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;

  const _LedgerMetricItem({
    required this.title,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
