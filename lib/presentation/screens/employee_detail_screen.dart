import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/i18n/app_strings.dart';
import '../../core/models/attendance_status.dart';
import '../../state/register_provider.dart';
import '../widgets/add_employee_modal.dart';
import '../widgets/calendar_grid.dart';
import '../widgets/dark_ledger_card.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../widgets/record_payment_modal.dart';
import '../widgets/summary_stat_card.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final String employeeId;

  const EmployeeDetailScreen({
    super.key,
    required this.employeeId,
  });

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {

  void _showPaymentModal(BuildContext context, bool isAdvance, String name, double currentPaid, double currentAdvance, {bool isEditMode = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RecordPaymentModal(
        employeeId: widget.employeeId,
        employeeName: name,
        isAdvance: isAdvance,
        isEditMode: isEditMode,
        currentPaid: currentPaid,
        currentAdvance: currentAdvance,
      ),
    );
  }

  void _shareWhatsAppReport(BuildContext context, dynamic employee, RegisterProvider provider) async {
    final strings = provider.strings;
    final headerName = provider.businessName.isNotEmpty
        ? provider.businessName
        : (provider.ownerName.isNotEmpty ? provider.ownerName : 'MUSTER KHATA');

    final reportText = '''
📋 *${headerName.toUpperCase()} - मस्टर रसीद*
----------------------------------------
👤 *मज़दूर का नाम*: ${employee.name} (${employee.role})
🗓️ *दैनिक दर*: ₹${employee.dailyRate.round()}/दिन
📅 *माह*: ${provider.monthYearLabel}

----------------------------------------
✔️ *पूरे दिन (Present)*: ${employee.fullDaysCount} दिन
🌗 *आधा दिन (Half Day)*: ${employee.halfDaysCount} दिन
❌ *अनुपस्थित (Absent)*: ${employee.absentDaysCount} दिन

----------------------------------------
💰 *कुल कमाई (Earned)*: ₹${employee.earnedAmount.round()}
💵 *कुल दिया गया (Paid)*: ₹${employee.paid.round()}
💳 *एडवांस (Advance)*: ₹${employee.advance.round()}
🔴 *बाकी हिसाब (Balance Due)*: ₹${employee.dueAmount.round()}
----------------------------------------
_डिजिटल खाता रजिस्टर द्वारा जनरेट किया गया_
''';

    final encodedText = Uri.encodeComponent(reportText);
    final whatsappUrl = Uri.parse('whatsapp://send?text=$encodedText');
    final webUrl = Uri.parse('https://wa.me/?text=$encodedText');

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl);
      } else if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch WhatsApp';
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.isHindi
              ? '${employee.name} की व्हाट्सएप रसीद जनरेट हो गई!'
              : 'WhatsApp Slip for ${employee.name} generated!'),
          backgroundColor: AppColors.navyLedger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _getAttendanceLabel(AttendanceStatus status, AppStrings strings) {
    switch (status) {
      case AttendanceStatus.present:
        return strings.presentLabel;
      case AttendanceStatus.halfDay:
        return strings.halfDayLabel;
      case AttendanceStatus.absent:
        return strings.absentLabel;
      case AttendanceStatus.unMarked:
        return strings.notMarked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = RegisterProviderScope.of(context);
    final strings = provider.strings;
    final index = provider.employees.indexWhere((e) => e.id == widget.employeeId);
    if (index == -1) {
      return const Scaffold(
        backgroundColor: AppColors.bgParchment,
      );
    }
    final employee = provider.employees[index];
    final todayStatus = employee.todayStatus(provider.todayDay);

    return Scaffold(
      backgroundColor: AppColors.bgParchment,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Back button, Name, Edit, Delete, WhatsApp Slip
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderCard),
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: AppColors.textDark,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'emp_name_${employee.id}',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              employee.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${employee.role} · ₹${employee.dailyRate.round()}/day',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),

                  // Edit Worker Action Button
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (ctx) => AddEmployeeModal(
                          employeeId: employee.id,
                          initialName: employee.name,
                          initialRole: employee.role,
                          initialRate: employee.dailyRate,
                          isEditMode: true,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderCard),
                      ),
                      child: const Icon(Icons.edit_outlined, size: 18, color: AppColors.navyLedger),
                    ),
                  ),
                  const SizedBox(width: 6),

                  // Delete Worker Action Button
                  GestureDetector(
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => DeleteConfirmationDialog(
                          employeeId: employee.id,
                          employeeName: employee.name,
                        ),
                      );
                      if (confirm == true && mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEB),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.stampABorder),
                      ),
                      child: const Icon(Icons.delete_outline, size: 18, color: AppColors.stampABorder),
                    ),
                  ),
                  const SizedBox(width: 6),

                  // WhatsApp Share Action Button
                  GestureDetector(
                    onTap: () => _shareWhatsAppReport(context, employee, provider),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderCard),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.share, size: 16, color: Color(0xFF25D366)),
                          const SizedBox(width: 4),
                          Text(
                            strings.isHindi ? 'रसीद' : 'Slip',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Today Attendance Quick-Mark Card
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderCard),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x05000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today, Aug ${provider.todayDay}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _getAttendanceLabel(todayStatus, strings),
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _StampSelectBtn(
                          code: 'P',
                          color: AppColors.stampPBorder,
                          isSelected: todayStatus == AttendanceStatus.present,
                          onTap: () => provider.markTodayAttendance(
                              employee.id, AttendanceStatus.present),
                        ),
                        const SizedBox(width: 8),
                        _StampSelectBtn(
                          code: 'H',
                          color: AppColors.stampHBorder,
                          isSelected: todayStatus == AttendanceStatus.halfDay,
                          onTap: () => provider.markTodayAttendance(
                              employee.id, AttendanceStatus.halfDay),
                        ),
                        const SizedBox(width: 8),
                        _StampSelectBtn(
                          code: 'A',
                          color: AppColors.stampABorder,
                          isSelected: todayStatus == AttendanceStatus.absent,
                          onTap: () => provider.markTodayAttendance(
                              employee.id, AttendanceStatus.absent),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Quick Stats Summary Row
              SummaryStatRow(
                fullDays: employee.fullDaysCount,
                halfDays: employee.halfDaysCount,
                absentDays: employee.absentDaysCount,
                fullDaysLabel: strings.fullDays,
                halfDaysLabel: strings.halfDays,
                absentLabel: strings.absent,
              ),
              const SizedBox(height: 16),

              // Dark Navy Ledger Earnings Card
              DarkLedgerCard(
                earned: employee.earnedAmount,
                paid: employee.paid,
                advance: employee.advance,
                due: employee.dueAmount,
                earnedLabel: strings.earned,
                paidLabel: strings.paid,
                advanceLabel: strings.advance,
                balanceDueLabel: strings.balanceDue,
                recordPaymentLabel: strings.recordPayment,
                giveAdvanceLabel: strings.giveAdvance,
                onRecordPayment: () =>
                    _showPaymentModal(context, false, employee.name, employee.paid, employee.advance),
                onGiveAdvance: () =>
                    _showPaymentModal(context, true, employee.name, employee.paid, employee.advance),
              ),
              const SizedBox(height: 8),

              // August Attendance Calendar Grid Section
              Row(
                children: [
                  const Icon(Icons.calendar_month_outlined,
                      size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 8),
                  Text(
                    strings.augustAttendance,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CalendarGridWidget(
                attendanceMap: employee.augustAttendance,
                currentDay: provider.todayDay,
                onDayTap: (day) => provider.cycleDayAttendance(employee.id, day),
              ),
              const SizedBox(height: 24),
                          ]),
                        ),
                      
                  
        ),
      );
  }
}

class _StampSelectBtn extends StatelessWidget {
  final String code;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _StampSelectBtn({
    required this.code,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color,
            width: isSelected ? 2.0 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withAlpha(89),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          code,
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}
