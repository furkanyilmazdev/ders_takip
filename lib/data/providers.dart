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

  Future<void> addTestStudent() async {
    final repo = ref.read(studentRepositoryProvider);
    final count = (await repo.getAll()).length;
    await repo.add(Student(name: 'Öğrenci ${count + 1}'));
    state = AsyncData(await repo.getAll());
  }
}

final studentsProvider = AsyncNotifierProvider<StudentsNotifier, List<Student>>(
  StudentsNotifier.new,
);
