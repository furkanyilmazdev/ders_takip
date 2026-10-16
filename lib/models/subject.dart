import 'package:uuid/uuid.dart';

class Subject {
  final String id;
  final String title;

  Subject({String? id, required this.title}) : id = id ?? const Uuid().v4();
}
