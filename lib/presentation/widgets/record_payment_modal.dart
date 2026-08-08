import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../state/register_provider.dart';

class RecordPaymentModal extends StatefulWidget {
  final String employeeId;
  final String employeeName;
  final bool isAdvance;

  const RecordPaymentModal({
    super.key,
    required this.employeeId,
    required this.employeeName,
    this.isAdvance = false,
  });

  @override
  State<RecordPaymentModal> createState() => _RecordPaymentModalState();
}

class _RecordPaymentModalState extends State<RecordPaymentModal> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount != null && amount > 0) {
      final provider = RegisterProviderScope.of(context);
      provider.addPayment(
        widget.employeeId,
        amount,
        isAdvance: widget.isAdvance,
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = RegisterProviderScope.of(context);
    final strings = provider.strings;

    final titleText = widget.isAdvance ? strings.giveCashAdvance : strings.recordSalaryPayment;
    final buttonText = widget.isAdvance ? strings.saveAdvance : strings.savePayment;

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bgParchment,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titleText,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textMuted),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          Text(
            '${strings.workerLabel}: ${widget.employeeName}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            strings.amountInRs,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            autofocus: true,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            decoration: InputDecoration(
              prefixText: '₹ ',
              prefixStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              hintText: '1000',
              filled: true,
              fillColor: AppColors.bgCard,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.borderCard),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: const BorderSide(color: AppColors.borderCard),
                  ),
                  child: Text(strings.cancel,
                      style: const TextStyle(color: AppColors.textDark)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isAdvance
                        ? AppColors.goldAccent
                        : AppColors.navyLedger,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
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
