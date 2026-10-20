import '../models/student.dart';
import 'student_repository.dart';

class InMemoryStudentRepository implements StudentRepository {
  final List<Student> _students = [];

  @override
  Future<List<Student>> getAll() async {
    return _students.where((s) => s.deletedAt == null).toList();
  }

  @override
  Future<void> add(Student student) async {
    _students.add(student);
  }
}
