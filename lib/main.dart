import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'models/student.dart';
import 'services/api_service.dart';
import 'student_detail_screen.dart';
import 'student_form_screen.dart'; 

final _logger = Logger('StudentListScreenState');

void main() {
  runApp(MyApp(apiService: ApiService('http://10.0.2.2/api/students.php')));  // Adjust URL for testing
}

class MyApp extends StatelessWidget {
  final ApiService apiService;

  const MyApp({super.key, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StudentListScreen(apiService: apiService), 
      debugShowCheckedModeBanner: false,
    );
  }
}

class StudentListScreen extends StatefulWidget {
  final ApiService apiService;

  const StudentListScreen({super.key, required this.apiService});

  @override
  StudentListScreenState createState() => StudentListScreenState();
}

class StudentListScreenState extends State<StudentListScreen> {
  late Future<List<Student>> students;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  void _fetchStudents() {
    students = widget.apiService.getStudents();
    students.then((value) {
      _logger.info('Fetched students: $value');
    }).catchError((error) {
      _logger.severe('Error fetching students: $error');
    });
  }

  Future<void> _refreshStudents() async {
    setState(() {
      _fetchStudents();
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _showDeleteConfirmationDialog(Student student) async {
    final bool? confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete ${student.firstName} ${student.lastName}?'),
          content: const Text('Are you sure you want to delete this student?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await widget.apiService.deleteStudent(student.id);
      _showSnackbar('Student deleted');
      _refreshStudents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Enrollment List'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshStudents,
        child: FutureBuilder<List<Student>>(
          future: students,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No students found'));
            }

            final students = snapshot.data!;

            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  child: ListTile(
                    title: Text('${student.firstName} ${student.lastName}'),
                    onTap: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentDetailScreen(
                            student: student,
                            apiService: widget.apiService,
                          ),
                        ),
                      );
                      if (updated == true) {
                        _showSnackbar('Student updated');
                        _refreshStudents();
                      }
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _showDeleteConfirmationDialog(student),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newStudent = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentFormScreen(apiService: widget.apiService),
            ),
          );
          if (newStudent != null) {
            _showSnackbar('Student added');
            _refreshStudents();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}







