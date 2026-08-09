import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/i18n/app_strings.dart';
import '../../core/models/attendance_status.dart';
import '../../state/register_provider.dart';
import '../widgets/calendar_grid.dart';
import '../widgets/dark_ledger_card.dart';
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
  final _workLogController = TextEditingController();

  @override
  void dispose() {
    _workLogController.dispose();
    super.dispose();
  }

  void _showPaymentModal(BuildContext context, bool isAdvance, String name) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RecordPaymentModal(
        employeeId: widget.employeeId,
        employeeName: name,
        isAdvance: isAdvance,
      ),
    );
  }

  void _shareWhatsAppReport(BuildContext context, dynamic employee, AppStrings strings) {
    final reportText = '''
📋 *${strings.appTitle}*
👤 *${employee.name}* (${employee.role})
🗓️ Rate: ₹${employee.dailyRate.round()}/day

✔️ ${strings.fullDays}: ${employee.fullDaysCount}
🌗 ${strings.halfDays}: ${employee.halfDaysCount}
❌ ${strings.absent}: ${employee.absentDaysCount}

💰 ${strings.earned}: ₹${employee.earnedAmount.round()}
💵 ${strings.paid}: ₹${employee.paid.round()}
💳 ${strings.advance}: ₹${employee.advance.round()}
🔴 *${strings.balanceDue}: ₹${employee.dueAmount.round()}*
''';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.greenAccent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                strings.isHindi
                    ? '${employee.name} की व्हाट्सएप रसीद तैयार है!'
                    : 'WhatsApp Slip generated for ${employee.name}!',
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.navyLedger,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
    final employee = provider.employees.firstWhere(
      (e) => e.id == widget.employeeId,
      orElse: () => provider.employees.first,
    );

    final todayStatus = employee.todayStatus(provider.todayDay);

    return Scaffold(
      backgroundColor: AppColors.bgParchment,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header with Back Button and Share Button
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
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee.name,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${employee.role} · ₹${employee.dailyRate.round()}/day',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // WhatsApp Share Action Button
                  GestureDetector(
                    onTap: () => _shareWhatsAppReport(context, employee, strings),
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
                    _showPaymentModal(context, false, employee.name),
                onGiveAdvance: () =>
                    _showPaymentModal(context, true, employee.name),
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

              // Work Log Section
              Row(
                children: [
                  const Icon(Icons.assignment_outlined,
                      size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 8),
                  Text(
                    strings.workLog,
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderCard),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (employee.workLogs.isEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          strings.noWorkNotes,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textLight,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ] else ...[
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: employee.workLogs.length,
                        separatorBuilder: (ctx, i) =>
                            const SizedBox(height: 12),
                        itemBuilder: (ctx, index) {
                          final log = employee.workLogs[index];
                          return Container(
                            padding: const EdgeInsets.only(left: 12),
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: AppColors.navyLedger,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  log.formattedDate,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  log.note,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textDark,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                    // Add Work Log Field
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _workLogController,
                            style: const TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.mic, color: AppColors.navyLedger, size: 20),
                                onPressed: () {
                                  _workLogController.text = strings.isHindi
                                      ? 'आज पिलर की ढलाई और सीमेंट मिक्सिंग का काम पूरा हुआ (आवाज़ से नोट)'
                                      : 'Pillar alignment & cement mixing completed (Voice Note)';
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(strings.isHindi
                                          ? '🎙️ आवाज़ दर्ज हो गई!'
                                          : '🎙️ Voice Note Recorded!'),
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: AppColors.navyLedger,
                                    ),
                                  );
                                },
                              ),
                              filled: true,
                              fillColor: const Color(0xFFFAF8F2),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.borderCard),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.borderCard),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.navyLedger),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (_workLogController.text.trim().isNotEmpty) {
                              provider.addWorkLog(
                                  employee.id, _workLogController.text);
                              _workLogController.clear();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.navyLedger,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            strings.addBtn,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
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
