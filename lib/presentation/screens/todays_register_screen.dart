import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/i18n/app_strings.dart';
import '../../core/models/attendance_status.dart';
import '../../core/models/employee_model.dart';
import '../../state/register_provider.dart';
import '../widgets/add_employee_modal.dart';
import '../widgets/app_drawer.dart';
import '../widgets/dummy_ad_banner.dart';
import '../widgets/ink_stamp.dart';
import 'employee_detail_screen.dart';

class TodaysRegisterScreen extends StatefulWidget {
  const TodaysRegisterScreen({super.key});

  @override
  State<TodaysRegisterScreen> createState() => _TodaysRegisterScreenState();
}

class _TodaysRegisterScreenState extends State<TodaysRegisterScreen> {
  bool _isSearchVisible = false;

  void _showAddEmployeeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AddEmployeeModal(),
    );
  }

  String _formatDue(double due, AppStrings strings) {
    final val = due.round();
    return '${strings.dueTagPrefix} ₹$val';
  }

  @override
  Widget build(BuildContext context) {
    final provider = RegisterProviderScope.of(context);
    final strings = provider.strings;
    final employees = provider.employees;

    return Scaffold(
      backgroundColor: AppColors.bgParchment,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Small Subtitle & Hamburger Drawer Menu Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            provider.ownerName.isNotEmpty
                                ? '${provider.ownerName.toUpperCase()} · ${strings.musterAugust}'
                                : strings.musterAugust,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: Color(0xFF7B8898),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Builder(
                          builder: (ctx) => GestureDetector(
                            onTap: () => Scaffold.of(ctx).openDrawer(),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.bgCard,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.borderCard),
                              ),
                              child: const Icon(
                                Icons.menu,
                                color: AppColors.navyLedger,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Title and Search Icon Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            strings.todaysRegister,
                            style: const TextStyle(
                              fontFamily: 'serif',
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isSearchVisible ? Icons.close : Icons.search,
                            color: AppColors.textDark,
                          ),
                          onPressed: () {
                            setState(() {
                              _isSearchVisible = !_isSearchVisible;
                              if (!_isSearchVisible) {
                                provider.setSearchQuery('');
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Offline Indicator Banner (if offline)
                    if (provider.isOffline) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3CD),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFFECB5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.wifi_off,
                                size: 16, color: Color(0xFF856404)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                strings.isHindi
                                    ? 'ऑफ़लाइन मोड · डेटा सेव हो रहा है, इंटरनेट आने पर सिंक होगा'
                                    : 'Offline Mode · Data saving locally, will auto-sync on connection',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF856404),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    // Search Bar if expanded
                    if (_isSearchVisible) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderCard),
                        ),
                        child: TextField(
                          onChanged: provider.setSearchQuery,
                          decoration: InputDecoration(
                            hintText: strings.searchHint,
                            border: InputBorder.none,
                            icon: const Icon(Icons.search,
                                size: 18, color: AppColors.textMuted),
                          ),
                        ),
                      ),
                    ],
                    // Quick Register Ribbon Summary
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0x99F0E8D8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderCard),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _RibbonStat(
                            value: '${provider.totalEmployeesCount}',
                            label: strings.workers,
                          ),
                          _RibbonStat(
                            value: '${provider.todayPresentCount}',
                            label: strings.present,
                          ),
                          _RibbonStat(
                            value:
                                '₹${provider.totalRegisterEarned.round()}',
                            label: strings.earned,
                          ),
                          _RibbonStat(
                            value:
                                '₹${provider.totalRegisterDue.round()}',
                            label: strings.totalDue,
                            isWarning: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Demo AdMob Sponsor Banner (Hidden if Pro User)
                    const DummyAdBannerWidget(),
                    const SizedBox(height: 12),
                    if (employees.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            strings.isHindi ? 'मज़दूरों की सूची' : 'Worker List',
                            style: const TextStyle(
                              fontFamily: 'serif',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              provider.markAllTodayPresent();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(strings.isHindi
                                      ? 'सभी मज़दूरों की आज की P (Present) लग गई! ⚡'
                                      : 'All workers marked Present today! ⚡'),
                                  backgroundColor: AppColors.navyLedger,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.stampPBorder.withAlpha(25),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: AppColors.stampPBorder),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.bolt,
                                      size: 14,
                                      color: AppColors.stampPBorder),
                                  const SizedBox(width: 4),
                                  Text(
                                    strings.isHindi
                                        ? 'सबको P लगाएं'
                                        : 'Mark All Present',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.stampPBorder,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ),

            // Employee List or Empty State
            if (employees.isEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0x88FFFDF7),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.borderCard),
                        ),
                        child: const Icon(Icons.group_add_outlined,
                            size: 36, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        strings.noWorkersYet,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        strings.noWorkersSub,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final emp = employees[index];
                      final todayStatus = emp.todayStatus(provider.todayDay);

                      return _EmployeeCard(
                        employee: emp,
                        todayStatus: todayStatus,
                        formattedDue: _formatDue(emp.dueAmount, strings),
                        onTap: () {
                          provider.selectEmployee(emp.id);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => EmployeeDetailScreen(
                                employeeId: emp.id,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: employees.length,
                  ),
                ),
              ),
            ],

            // Add Employee Dashed Card at Bottom
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
                child: InkWell(
                  onTap: () => _showAddEmployeeSheet(context),
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFC8BEAF),
                        width: 1.5,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, color: AppColors.navyLedger, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          strings.addEmployee,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navyLedger,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RibbonStat extends StatelessWidget {
  final String value;
  final String label;
  final bool isWarning;

  const _RibbonStat({
    required this.value,
    required this.label,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isWarning ? const Color(0xFFC25B12) : AppColors.textDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final Employee employee;
  final AttendanceStatus todayStatus;
  final String formattedDue;
  final VoidCallback onTap;

  const _EmployeeCard({
    required this.employee,
    required this.todayStatus,
    required this.formattedDue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderCard),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Initials Avatar Circle
                Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    color: AppColors.navyLedger,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    employee.initials,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Employee Details (Name & Role/Rate)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.name,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${employee.role} · ₹${employee.dailyRate.round()}/day',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Today Ink Stamp Badge
                InkStampWidget(
                  status: todayStatus,
                  size: 32,
                ),
                const SizedBox(width: 10),
                // Due Amount Tag & Chevron
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formattedDue,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFFA09586),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
