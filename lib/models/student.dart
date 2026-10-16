import 'package:uuid/uuid.dart';

class Student {
  final String id;
  final String name;
  final String? meetLink;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Student({
    String? id,
    required this.name,
    this.meetLink,
    DateTime? updatedAt,
    this.deletedAt,
  }) : id = id ?? const Uuid().v4(),
       updatedAt = updatedAt ?? DateTime.now().toUtc();
}
