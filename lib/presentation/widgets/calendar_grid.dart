import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/attendance_status.dart';
import 'ink_stamp.dart';

class CalendarGridWidget extends StatelessWidget {
  final Map<int, AttendanceStatus> attendanceMap;
  final Function(int day)? onDayTap;
  final int currentDay;

  const CalendarGridWidget({
    super.key,
    required this.attendanceMap,
    this.onDayTap,
    this.currentDay = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderCard),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grid of Days (6 items per row as in screenshot)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 30,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 16,
              crossAxisSpacing: 8,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index + 1;
              final status = attendanceMap[dayNumber] ?? AttendanceStatus.unMarked;
              final isPastOrToday = dayNumber <= currentDay;

              return InkWell(
                onTap: isPastOrToday && onDayTap != null
                    ? () => onDayTap!(dayNumber)
                    : null,
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkStampWidget(
                      status: status,
                      size: 34,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$dayNumber',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isPastOrToday
                            ? AppColors.textDark
                            : AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
