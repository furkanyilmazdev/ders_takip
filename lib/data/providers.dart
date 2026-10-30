import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/student.dart';
import 'in_memory_student_repository.dart';
import 'student_repository.dart';

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return InMemoryStudentRepository();
});

class StudentsNotifier extends AsyncNotifier<List<Student>> {
  @override
  Future<List<Student>> build() {
    return ref.watch(studentRepositoryProvider).getAll();
  }

  Future<void> addStudent(String name) async {
    final repo = ref.read(studentRepositoryProvider);
    await repo.add(Student(name: name));
    state = AsyncData(await repo.getAll());
  }
}

final studentsProvider = AsyncNotifierProvider<StudentsNotifier, List<Student>>(
  StudentsNotifier.new,
);
