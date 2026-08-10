import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../state/register_provider.dart';

class AddEmployeeModal extends StatefulWidget {
  final String? employeeId;
  final String? initialName;
  final String? initialRole;
  final double? initialRate;
  final bool isEditMode;

  const AddEmployeeModal({
    super.key,
    this.employeeId,
    this.initialName,
    this.initialRole,
    this.initialRate,
    this.isEditMode = false,
  });

  @override
  State<AddEmployeeModal> createState() => _AddEmployeeModalState();
}

class _AddEmployeeModalState extends State<AddEmployeeModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _roleController;
  late final TextEditingController _rateController;
  late final TextEditingController _advanceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _roleController = TextEditingController(text: widget.initialRole ?? '');
    _rateController = TextEditingController(
        text: widget.initialRate != null ? widget.initialRate!.round().toString() : '');
    _advanceController = TextEditingController();
  }

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

      if (widget.isEditMode && widget.employeeId != null) {
        provider.updateEmployeeDetails(
          id: widget.employeeId!,
          name: name,
          role: role,
          dailyRate: rate,
        );
      } else {
        provider.addNewEmployee(
          name: name,
          role: role,
          dailyRate: rate,
          initialAdvance: advance,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
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
                    widget.isEditMode
                        ? (isHindi ? 'मज़दूर की जानकारी एडिट करें' : 'Edit Worker Details')
                        : strings.addNewWorker,
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
              const SizedBox(height: 16),

              // Name Field
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: strings.workerName,
                  hintText: strings.workerNameHint,
                  prefixIcon: const Icon(Icons.person_outline,
                      size: 20, color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.bgCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.borderCard),
                  ),
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? strings.workerNameError : null,
              ),
              const SizedBox(height: 14),

              // Role / Occupation Field
              TextFormField(
                controller: _roleController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: strings.roleOccupation,
                  hintText: strings.roleOccupationHint,
                  prefixIcon: const Icon(Icons.work_outline,
                      size: 20, color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.bgCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.borderCard),
                  ),
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? strings.roleOccupationError : null,
              ),
              const SizedBox(height: 14),

              // Daily Rate Field
              TextFormField(
                controller: _rateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: strings.dailyRate,
                  prefixText: '₹ ',
                  prefixStyle: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.textDark),
                  filled: true,
                  fillColor: AppColors.bgCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.borderCard),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return strings.dailyRateError;
                  }
                  if (double.tryParse(val.trim()) == null) {
                    return isHindi ? 'कृपया सही संख्या दर्ज करें' : 'Enter valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Initial Advance Field (Only in Add mode)
              if (!widget.isEditMode) ...[
                TextFormField(
                  controller: _advanceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: strings.initialAdvance,
                    hintText: strings.initialAdvanceHint,
                    prefixText: '₹ ',
                    prefixStyle: const TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.textDark),
                    filled: true,
                    fillColor: AppColors.bgCard,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.borderCard),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Save / Submit Button
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
                    widget.isEditMode
                        ? (isHindi ? 'बदलाव सेव करें' : 'Save Edits')
                        : strings.saveEmployee,
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
        ),
      ),
    );
  }
}
