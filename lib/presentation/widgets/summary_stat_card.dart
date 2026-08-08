import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SummaryStatRow extends StatelessWidget {
  final int fullDays;
  final int halfDays;
  final int absentDays;
  final String fullDaysLabel;
  final String halfDaysLabel;
  final String absentLabel;

  const SummaryStatRow({
    super.key,
    required this.fullDays,
    required this.halfDays,
    required this.absentDays,
    this.fullDaysLabel = 'Full days',
    this.halfDaysLabel = 'Half days',
    this.absentLabel = 'Absent',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            count: fullDays,
            label: fullDaysLabel,
            bgColor: AppColors.statGreenBg,
            textColor: AppColors.statGreenText,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatBox(
            count: halfDays,
            label: halfDaysLabel,
            bgColor: AppColors.statYellowBg,
            textColor: AppColors.statYellowText,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatBox(
            count: absentDays,
            label: absentLabel,
            bgColor: AppColors.statRedBg,
            textColor: AppColors.statRedText,
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final int count;
  final String label;
  final Color bgColor;
  final Color textColor;

  const _StatBox({
    required this.count,
    required this.label,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5F6368),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
