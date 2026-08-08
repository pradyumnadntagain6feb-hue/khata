import 'package:flutter/material.dart';
import '../core/i18n/app_strings.dart';
import '../core/models/attendance_status.dart';
import '../core/models/employee_model.dart';
import '../core/models/work_log_model.dart';

class RegisterProvider extends ChangeNotifier {
  final int todayDay = 18; // Today is August 18th
  final String monthYearLabel = 'AUGUST 2026';

  AppLanguage _language = AppLanguage.english;
  bool _isFirstTimeUser = true;

  List<Employee> _employees = []; // Clean empty register by default!
  String _searchQuery = '';
  String? _selectedEmployeeId;

  final List<Map<String, String>> _submittedFeedbackList = [];

  RegisterProvider() {
    // Starts with a clean empty list for real user entry
    _employees = [];
  }

  // Language & Localization getters
  AppLanguage get language => _language;
  bool get isFirstTimeUser => _isFirstTimeUser;
  AppStrings get strings => AppStrings(_language);

  void setLanguage(AppLanguage lang) {
    _language = lang;
    notifyListeners();
  }

  void completeOnboarding(AppLanguage chosenLang) {
    _language = chosenLang;
    _isFirstTimeUser = false;
    notifyListeners();
  }

  void clearAllSampleData() {
    _employees.clear();
    _selectedEmployeeId = null;
    notifyListeners();
  }

  /// Option to load demo sample workers if needed
  void loadSampleDemoData() {
    _initSampleData();
    notifyListeners();
  }

  void submitFeedback(String category, String message) {
    _submittedFeedbackList.add({
      'timestamp': DateTime.now().toIso8601String(),
      'category': category,
      'message': message,
    });
    notifyListeners();
  }

  List<Employee> get employees {
    if (_searchQuery.trim().isEmpty) {
      return _employees;
    }
    return _employees.where((emp) {
      return emp.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          emp.role.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Employee? get selectedEmployee {
    if (_selectedEmployeeId == null || _employees.isEmpty) return null;
    return _employees.firstWhere(
      (e) => e.id == _selectedEmployeeId,
      orElse: () => _employees.first,
    );
  }

  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void selectEmployee(String? id) {
    _selectedEmployeeId = id;
    notifyListeners();
  }

  /// Mark Today's Attendance (P, H, or A)
  void markTodayAttendance(String employeeId, AttendanceStatus status) {
    final index = _employees.indexWhere((e) => e.id == employeeId);
    if (index != -1) {
      final emp = _employees[index];
      final updatedAttendance = Map<int, AttendanceStatus>.from(emp.augustAttendance);
      updatedAttendance[todayDay] = status;

      _employees[index] = emp.copyWith(augustAttendance: updatedAttendance);
      notifyListeners();
    }
  }

  /// Toggle or set attendance for a specific day in the month
  void setDayAttendance(String employeeId, int day, AttendanceStatus status) {
    final index = _employees.indexWhere((e) => e.id == employeeId);
    if (index != -1) {
      final emp = _employees[index];
      final updatedAttendance = Map<int, AttendanceStatus>.from(emp.augustAttendance);
      updatedAttendance[day] = status;

      _employees[index] = emp.copyWith(augustAttendance: updatedAttendance);
      notifyListeners();
    }
  }

  /// Cycle attendance status for a day (Present -> Half Day -> Absent -> Present)
  void cycleDayAttendance(String employeeId, int day) {
    final index = _employees.indexWhere((e) => e.id == employeeId);
    if (index != -1) {
      final emp = _employees[index];
      final current = emp.augustAttendance[day] ?? AttendanceStatus.unMarked;
      AttendanceStatus nextStatus;
      switch (current) {
        case AttendanceStatus.present:
          nextStatus = AttendanceStatus.halfDay;
          break;
        case AttendanceStatus.halfDay:
          nextStatus = AttendanceStatus.absent;
          break;
        case AttendanceStatus.absent:
        case AttendanceStatus.unMarked:
          nextStatus = AttendanceStatus.present;
          break;
      }
      setDayAttendance(employeeId, day, nextStatus);
    }
  }

  /// Add new work log note
  void addWorkLog(String employeeId, String noteText) {
    if (noteText.trim().isEmpty) return;
    final index = _employees.indexWhere((e) => e.id == employeeId);
    if (index != -1) {
      final emp = _employees[index];
      final newLog = WorkLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime(2026, 8, todayDay),
        note: noteText.trim(),
      );
      final updatedLogs = [newLog, ...emp.workLogs];
      _employees[index] = emp.copyWith(workLogs: updatedLogs);
      notifyListeners();
    }
  }

  /// Record payment or advance
  void addPayment(String employeeId, double amount, {bool isAdvance = false}) {
    final index = _employees.indexWhere((e) => e.id == employeeId);
    if (index != -1) {
      final emp = _employees[index];
      if (isAdvance) {
        emp.advance += amount;
      } else {
        emp.paid += amount;
      }
      notifyListeners();
    }
  }

  /// Add a brand new employee
  void addNewEmployee({
    required String name,
    required String role,
    required double dailyRate,
    double initialAdvance = 0.0,
  }) {
    final newId = 'emp_${DateTime.now().millisecondsSinceEpoch}';
    final defaultAttendance = <int, AttendanceStatus>{};
    // Default today present
    for (int i = 1; i <= 17; i++) {
      defaultAttendance[i] = AttendanceStatus.present;
    }
    defaultAttendance[todayDay] = AttendanceStatus.present;

    final newEmployee = Employee(
      id: newId,
      name: name.trim(),
      role: role.trim(),
      dailyRate: dailyRate,
      advance: initialAdvance,
      augustAttendance: defaultAttendance,
      workLogs: [
        WorkLog(
          id: 'log_init',
          date: DateTime(2026, 8, todayDay),
          note: 'Joined muster register. Initial onboarding completed.',
        )
      ],
    );

    _employees.add(newEmployee);
    notifyListeners();
  }

  // Quick stats calculations for overall register ribbon
  int get totalEmployeesCount => _employees.length;

  int get todayPresentCount => _employees
      .where((e) => e.todayStatus(todayDay) == AttendanceStatus.present)
      .length;

  double get totalRegisterDue =>
      _employees.fold(0.0, (sum, emp) => sum + emp.dueAmount);

  double get totalRegisterEarned =>
      _employees.fold(0.0, (sum, emp) => sum + emp.earnedAmount);

  void _initSampleData() {
    final rameshAttendance = <int, AttendanceStatus>{
      1: AttendanceStatus.present,
      2: AttendanceStatus.present,
      3: AttendanceStatus.present,
      4: AttendanceStatus.halfDay,
      5: AttendanceStatus.present,
      6: AttendanceStatus.absent,
      7: AttendanceStatus.present,
      8: AttendanceStatus.present,
      9: AttendanceStatus.present,
      10: AttendanceStatus.present,
      11: AttendanceStatus.halfDay,
      12: AttendanceStatus.present,
      13: AttendanceStatus.present,
      14: AttendanceStatus.absent,
      15: AttendanceStatus.present,
      16: AttendanceStatus.present,
      17: AttendanceStatus.present,
      18: AttendanceStatus.present,
    };

    final sureshAttendance = <int, AttendanceStatus>{};
    for (int i = 1; i <= 18; i++) {
      if (i == 5) {
        sureshAttendance[i] = AttendanceStatus.halfDay;
      } else if (i == 9 || i == 15) {
        sureshAttendance[i] = AttendanceStatus.absent;
      } else {
        sureshAttendance[i] = AttendanceStatus.present;
      }
    }

    final vikramAttendance = <int, AttendanceStatus>{};
    for (int i = 1; i <= 18; i++) {
      if (i <= 10) {
        vikramAttendance[i] = AttendanceStatus.present;
      } else {
        vikramAttendance[i] = AttendanceStatus.absent;
      }
    }
    vikramAttendance[18] = AttendanceStatus.present;

    _employees = [
      Employee(
        id: 'emp_1',
        name: 'Ramesh Yadav',
        role: 'Site Mason',
        dailyRate: 650.0,
        paid: 5200.0,
        advance: 500.0,
        augustAttendance: rameshAttendance,
        workLogs: [
          WorkLog(
            id: 'wl_1',
            date: DateTime(2026, 8, 18),
            note: 'Pillar 4 shuttering & alignment completed.',
          ),
        ],
      ),
      Employee(
        id: 'emp_2',
        name: 'Suresh Kumar',
        role: 'Helper',
        dailyRate: 450.0,
        paid: 2925.0,
        advance: 0.0,
        augustAttendance: sureshAttendance,
        workLogs: [
          WorkLog(
            id: 'wl_4',
            date: DateTime(2026, 8, 18),
            note: 'Cement bag shifting & mortar mixing helper.',
          ),
        ],
      ),
      Employee(
        id: 'emp_3',
        name: 'Vikram Singh',
        role: 'Electrician',
        dailyRate: 800.0,
        paid: 5000.0,
        advance: 0.0,
        augustAttendance: vikramAttendance,
        workLogs: [
          WorkLog(
            id: 'wl_5',
            date: DateTime(2026, 8, 18),
            note: 'Main distribution board wiring & earthing test.',
          ),
        ],
      ),
    ];
  }
}

class RegisterProviderScope extends InheritedNotifier<RegisterProvider> {
  const RegisterProviderScope({
    super.key,
    required RegisterProvider provider,
    required super.child,
  }) : super(notifier: provider);

  static RegisterProvider of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<RegisterProviderScope>();
    assert(scope != null, 'No RegisterProviderScope found in context');
    return scope!.notifier!;
  }
}
