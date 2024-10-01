import 'package:flutter/material.dart';
import 'models/student.dart';
import 'services/api_service.dart';
import 'student_form_screen.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;
  final ApiService apiService;

  const StudentDetailScreen({super.key, required this.student, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Name: ${student.firstName} ${student.lastName}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Course: ${student.course}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Year: ${student.year}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Enrolled: ${student.enrolled ? 'Yes' : 'No'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    final updatedStudent = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentFormScreen(
                          student: student,
                          apiService: apiService,
                        ),
                      ),
                    );
                    if (updatedStudent != null) {
                      try {
                        await apiService.updateStudent(updatedStudent);
                        Navigator.pop(context, true);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to update student: $e')),
                        );
                      }
                    }
                  },
                  child: const Text('Update'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await apiService.deleteStudent(student.id);
                      Navigator.pop(context, true);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to delete student: $e')),
                      );
                    }
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


