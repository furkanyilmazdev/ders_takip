import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ders_takip/screens/add_student_dialog.dart';

import '../data/providers.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Öğrenciler')),
      body: students.when(
        data: (list) => ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(list[index].name));
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Hata: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final name = await showDialog<String>(
            context: context,
            builder: (context) => const AddStudentDialog(),
          );
          if (name != null) {
            ref.read(studentsProvider.notifier).addStudent(name);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
