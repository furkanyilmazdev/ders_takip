import 'package:uuid/uuid.dart';

class LessonRule {
  final String id;
  final String studentId;
  final int weekday;
  final int startMinutes;
  final int durationMinutes;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  LessonRule({
    String? id,
    required this.studentId,
    required this.weekday,
    required this.startMinutes,
    this.durationMinutes = 60,
    DateTime? updatedAt,
    this.deletedAt,
  }) : id = id ?? const Uuid().v4(),
       updatedAt = updatedAt ?? DateTime.now().toUtc();
}
