import 'package:flutter/material.dart';
import 'models/student.dart';
import 'services/api_service.dart';
import 'student_form_screen.dart';  

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
    setState(() {
      students = widget.apiService.getStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Enrollment List'),
      ),
      body: FutureBuilder<List<Student>>(
        future: students,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _fetchStudents,  
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
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
                  onTap: () {
                  },
                ),
              );
            },
          );
        },
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
            _fetchStudents(); 
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
