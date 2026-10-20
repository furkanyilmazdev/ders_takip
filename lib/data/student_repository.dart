import '../models/student.dart';

abstract class StudentRepository {
  Future<List<Student>> getAll();
  Future<void> add(Student student);
}
