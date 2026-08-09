import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attendance_status.dart';
import '../models/employee_model.dart';
import '../models/work_log_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _employeesRef =>
      _db.collection('employees');

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _db.collection('users');

  CollectionReference<Map<String, dynamic>> get _feedbackRef =>
      _db.collection('feedback');

  /// Save Feedback & Feature Wishlist to Cloud Firestore
  Future<void> submitFeedback({
    required String category,
    required String message,
    String? userName,
    String? userEmail,
  }) async {
    await _feedbackRef.add({
      'category': category,
      'message': message,
      'userName': userName ?? '',
      'userEmail': userEmail ?? '',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Save Owner / Business Profile to Cloud Firestore
  Future<void> saveOwnerProfile({
    required String userId,
    required String ownerName,
    required String businessName,
    String? email,
  }) async {
    await _usersRef.doc(userId).set({
      'ownerName': ownerName,
      'businessName': businessName,
      'email': email ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Get Owner / Business Profile from Cloud Firestore
  Future<Map<String, dynamic>?> getOwnerProfile(String userId) async {
    final doc = await _usersRef.doc(userId).get();
    return doc.data();
  }

  /// Stream of real-time employee list from Cloud Firestore
  Stream<List<Employee>> getEmployeesStream() {
    return _employeesRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return _employeeFromMap(doc.id, data);
      }).toList();
    });
  }

  /// Add new worker to Cloud Firestore
  Future<void> addEmployee(Employee employee) async {
    await _employeesRef.doc(employee.id).set(_employeeToMap(employee));
  }

  /// Update worker attendance status in Cloud Firestore
  Future<void> updateAttendance(
      String employeeId, Map<int, AttendanceStatus> attendance) async {
    final attendanceMap = <String, String>{};
    attendance.forEach((day, status) {
      attendanceMap[day.toString()] = status.name;
    });

    await _employeesRef.doc(employeeId).update({
      'augustAttendance': attendanceMap,
    });
  }

  /// Update worker paid / advance amount in Cloud Firestore
  Future<void> updatePayments(
      String employeeId, double paid, double advance) async {
    await _employeesRef.doc(employeeId).update({
      'paid': paid,
      'advance': advance,
    });
  }

  /// Add daily work log note to Cloud Firestore
  Future<void> addWorkLog(String employeeId, WorkLog log) async {
    final logMap = {
      'id': log.id,
      'date': log.date.toIso8601String(),
      'note': log.note,
    };

    await _employeesRef.doc(employeeId).update({
      'workLogs': FieldValue.arrayUnion([logMap]),
    });
  }

  /// Delete employee from Cloud Firestore
  Future<void> deleteEmployee(String employeeId) async {
    await _employeesRef.doc(employeeId).delete();
  }

  // Mapper Helpers
  Map<String, dynamic> _employeeToMap(Employee emp) {
    final attendanceMap = <String, String>{};
    emp.augustAttendance.forEach((day, status) {
      attendanceMap[day.toString()] = status.name;
    });

    final logsList = emp.workLogs.map((log) {
      return {
        'id': log.id,
        'date': log.date.toIso8601String(),
        'note': log.note,
      };
    }).toList();

    return {
      'name': emp.name,
      'role': emp.role,
      'dailyRate': emp.dailyRate,
      'paid': emp.paid,
      'advance': emp.advance,
      'augustAttendance': attendanceMap,
      'workLogs': logsList,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  Employee _employeeFromMap(String id, Map<String, dynamic> data) {
    final rawAttendance = data['augustAttendance'] as Map<String, dynamic>? ?? {};
    final attendanceMap = <int, AttendanceStatus>{};

    rawAttendance.forEach((key, val) {
      final day = int.tryParse(key);
      if (day != null) {
        final status = AttendanceStatus.values.firstWhere(
          (s) => s.name == val,
          orElse: () => AttendanceStatus.unMarked,
        );
        attendanceMap[day] = status;
      }
    });

    final rawLogs = data['workLogs'] as List<dynamic>? ?? [];
    final logsList = rawLogs.map((item) {
      final map = item as Map<String, dynamic>;
      return WorkLog(
        id: map['id'] ?? '',
        date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
        note: map['note'] ?? '',
      );
    }).toList();

    return Employee(
      id: id,
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      dailyRate: (data['dailyRate'] as num?)?.toDouble() ?? 0.0,
      paid: (data['paid'] as num?)?.toDouble() ?? 0.0,
      advance: (data['advance'] as num?)?.toDouble() ?? 0.0,
      augustAttendance: attendanceMap,
      workLogs: logsList,
    );
  }
}
