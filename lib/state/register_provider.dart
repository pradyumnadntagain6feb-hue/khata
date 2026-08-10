import 'dart:async';
import 'package:flutter/material.dart';
import '../core/i18n/app_strings.dart';
import '../core/models/attendance_status.dart';
import '../core/models/employee_model.dart';
import '../core/models/work_log_model.dart';
import '../core/services/firestore_service.dart';

class RegisterProvider extends ChangeNotifier {
  final int todayDay = 18;
  final String monthYearLabel = 'AUGUST 2026';

  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription<List<Employee>>? _firestoreSubscription;

  AppLanguage _language = AppLanguage.english;
  bool _isFirstTimeUser = true;

  String _ownerName = '';
  String _businessName = 'Muster Khata';
  bool _isProUser = false;
  bool _isOffline = false;

  String get ownerName => _ownerName;
  String get businessName => _businessName;
  bool get isProUser => _isProUser;
  bool get isOffline => _isOffline;

  void toggleOfflineMode(bool val) {
    _isOffline = val;
    notifyListeners();
  }

  void setOwnerProfile({required String name, required String businessName}) {
    _ownerName = name;
    _businessName = businessName;
    notifyListeners();
  }

  void upgradeToPro() {
    _isProUser = true;
    notifyListeners();
  }

  List<Employee> _employees = [];
  String _searchQuery = '';
  String? _selectedEmployeeId;

  final List<Map<String, String>> _submittedFeedbackList = [];

  RegisterProvider() {
    _initCloudSync();
  }

  /// Connect Real-Time Firestore Cloud Database Stream
  void _initCloudSync() {
    try {
      _firestoreSubscription =
          _firestoreService.getEmployeesStream().listen((cloudEmployees) {
        _employees = cloudEmployees;
        notifyListeners();
      }, onError: (error) {
        debugPrint('Firestore stream sync notice: $error');
      });
    } catch (e) {
      debugPrint('Firestore sync initialization notice: $e');
    }
  }

  @override
  void dispose() {
    _firestoreSubscription?.cancel();
    super.dispose();
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

  /// 1-Tap Quick Action: Mark all workers Present today
  void markAllTodayPresent() {
    for (int i = 0; i < _employees.length; i++) {
      final emp = _employees[i];
      final updatedAttendance = Map<int, AttendanceStatus>.from(emp.augustAttendance);
      updatedAttendance[todayDay] = AttendanceStatus.present;
      _employees[i] = emp.copyWith(augustAttendance: updatedAttendance);
      _firestoreService.updateAttendance(emp.id, updatedAttendance);
    }
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

      // Cloud Sync
      _firestoreService.updateAttendance(employeeId, updatedAttendance);
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

      // Cloud Sync
      _firestoreService.updateAttendance(employeeId, updatedAttendance);
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

      // Cloud Sync
      _firestoreService.addWorkLog(employeeId, newLog);
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

      // Cloud Sync
      _firestoreService.updatePayments(employeeId, emp.paid, emp.advance);
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
    // Only mark today's attendance on joining day; previous days stay unMarked
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

    // Cloud Sync to Firestore Database
    _firestoreService.addEmployee(newEmployee);
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
