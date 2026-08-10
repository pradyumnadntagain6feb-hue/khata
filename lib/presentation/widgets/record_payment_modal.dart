import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../state/register_provider.dart';

class RecordPaymentModal extends StatefulWidget {
  final String employeeId;
  final String employeeName;
  final bool isAdvance;
  final bool isEditMode;
  final double currentPaid;
  final double currentAdvance;

  const RecordPaymentModal({
    super.key,
    required this.employeeId,
    required this.employeeName,
    this.isAdvance = false,
    this.isEditMode = false,
    this.currentPaid = 0.0,
    this.currentAdvance = 0.0,
  });

  @override
  State<RecordPaymentModal> createState() => _RecordPaymentModalState();
}

class _RecordPaymentModalState extends State<RecordPaymentModal> {
  late final TextEditingController _amountController;
  late final TextEditingController _paidController;
  late final TextEditingController _advanceController;
  late bool _isEdit;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.isEditMode;
    _amountController = TextEditingController();
    _paidController = TextEditingController(text: widget.currentPaid.round().toString());
    _advanceController = TextEditingController(text: widget.currentAdvance.round().toString());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _paidController.dispose();
    _advanceController.dispose();
    super.dispose();
  }

  void _submit() {
    final provider = RegisterProviderScope.of(context);

    if (_isEdit) {
      final newPaid = double.tryParse(_paidController.text.trim()) ?? widget.currentPaid;
      final newAdvance = double.tryParse(_advanceController.text.trim()) ?? widget.currentAdvance;

      provider.updatePaidAndAdvance(
        widget.employeeId,
        paid: newPaid,
        advance: newAdvance,
      );
    } else {
      final amount = double.tryParse(_amountController.text.trim());
      if (amount != null && amount > 0) {
        provider.addPayment(
          widget.employeeId,
          amount,
          isAdvance: widget.isAdvance,
        );
      }
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = RegisterProviderScope.of(context);
    final strings = provider.strings;
    final isHindi = strings.isHindi;

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
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isEdit
                          ? (isHindi ? 'पेमेंट व एडवांस एडिट करें' : 'Edit Paid & Advance')
                          : (widget.isAdvance ? strings.giveCashAdvance : strings.recordSalaryPayment),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      widget.employeeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Mode Toggle (Add vs Edit)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _isEdit = !_isEdit;
                  });
                },
                icon: Icon(
                  _isEdit ? Icons.add_circle_outline : Icons.edit_note,
                  size: 18,
                  color: AppColors.navyLedger,
                ),
                label: Text(
                  _isEdit
                      ? (isHindi ? '+ नया जोड़ें' : '+ Add New')
                      : (isHindi ? '✏️ एडिट करें' : '✏️ Edit Amounts'),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navyLedger,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (_isEdit) ...[
            // Direct Paid Amount Field
            Text(
              isHindi ? 'कुल दिया गया भुगतान (Paid):' : 'Total Paid Amount:',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _paidController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: '₹ ',
                prefixStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                filled: true,
                fillColor: AppColors.bgCard,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.borderCard),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Direct Advance Amount Field
            Text(
              isHindi ? 'कुल एडवांस राशि (Advance):' : 'Total Advance Amount:',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _advanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: '₹ ',
                prefixStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                filled: true,
                fillColor: AppColors.bgCard,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.borderCard),
                ),
              ),
            ),
          ] else ...[
            // Amount Input Field
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              decoration: InputDecoration(
                prefixText: '₹ ',
                prefixStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                hintText: '0',
                hintStyle: const TextStyle(
                  fontSize: 20,
                  color: AppColors.textLight,
                ),
                filled: true,
                fillColor: AppColors.bgCard,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.borderCard),
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navyLedger,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                _isEdit
                    ? (isHindi ? 'अपडेट करें (Save Edits)' : 'Save Edits')
                    : (widget.isAdvance ? strings.saveAdvance : strings.savePayment),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
