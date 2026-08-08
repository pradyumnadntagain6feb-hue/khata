class WorkLog {
  final String id;
  final DateTime date;
  final String note;

  WorkLog({
    required this.id,
    required this.date,
    required this.note,
  });

  String get formattedDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
