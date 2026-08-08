import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../state/register_provider.dart';

class AddEmployeeModal extends StatefulWidget {
  const AddEmployeeModal({super.key});

  @override
  State<AddEmployeeModal> createState() => _AddEmployeeModalState();
}

class _AddEmployeeModalState extends State<AddEmployeeModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _rateController = TextEditingController();
  final _advanceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _rateController.dispose();
    _advanceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final role = _roleController.text.trim();
      final rate = double.tryParse(_rateController.text.trim()) ?? 500.0;
      final advance = double.tryParse(_advanceController.text.trim()) ?? 0.0;

      final provider = RegisterProviderScope.of(context);
      provider.addNewEmployee(
        name: name,
        role: role,
        dailyRate: rate,
        initialAdvance: advance,
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
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    strings.addNewWorker,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 20,
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
              const SizedBox(height: 16),
              _buildField(
                label: strings.workerName,
                controller: _nameController,
                hint: strings.workerNameHint,
                validator: (val) =>
                    val == null || val.isEmpty ? strings.workerNameError : null,
              ),
              const SizedBox(height: 12),
              _buildField(
                label: strings.roleOccupation,
                controller: _roleController,
                hint: strings.roleOccupationHint,
                validator: (val) =>
                    val == null || val.isEmpty ? strings.roleOccupationError : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildField(
                      label: strings.dailyRate,
                      controller: _rateController,
                      hint: strings.dailyRateHint,
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          val == null || val.isEmpty ? strings.dailyRateError : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildField(
                      label: strings.initialAdvance,
                      controller: _advanceController,
                      hint: strings.initialAdvanceHint,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
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
                    flex: 1,
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
                        strings.saveEmployee,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
            filled: true,
            fillColor: AppColors.bgCard,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderCard),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderCard),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.navyLedger),
            ),
          ),
        ),
      ],
    );
  }
}
