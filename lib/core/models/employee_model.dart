import 'attendance_status.dart';
import 'work_log_model.dart';

class Employee {
  final String id;
  final String name;
  final String role;
  final double dailyRate;
  double paid;
  double advance;
  final Map<int, AttendanceStatus> augustAttendance;
  final List<WorkLog> workLogs;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.dailyRate,
    this.paid = 0.0,
    this.advance = 0.0,
    required this.augustAttendance,
    required this.workLogs,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (name.isNotEmpty) {
      return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'EM';
  }

  int get fullDaysCount {
    return augustAttendance.values
        .where((status) => status == AttendanceStatus.present)
        .length;
  }

  int get halfDaysCount {
    return augustAttendance.values
        .where((status) => status == AttendanceStatus.halfDay)
        .length;
  }

  int get absentDaysCount {
    return augustAttendance.values
        .where((status) => status == AttendanceStatus.absent)
        .length;
  }

  double get earnedAmount {
    return (fullDaysCount * dailyRate) + (halfDaysCount * (dailyRate * 0.5));
  }

  double get dueAmount {
    final due = earnedAmount - paid - advance;
    return due < 0 ? 0 : due;
  }

  AttendanceStatus todayStatus(int currentDay) {
    return augustAttendance[currentDay] ?? AttendanceStatus.unMarked;
  }

  Employee copyWith({
    String? id,
    String? name,
    String? role,
    double? dailyRate,
    double? paid,
    double? advance,
    Map<int, AttendanceStatus>? augustAttendance,
    List<WorkLog>? workLogs,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      dailyRate: dailyRate ?? this.dailyRate,
      paid: paid ?? this.paid,
      advance: advance ?? this.advance,
      augustAttendance: augustAttendance ?? Map.from(this.augustAttendance),
      workLogs: workLogs ?? List.from(this.workLogs),
    );
  }
}
