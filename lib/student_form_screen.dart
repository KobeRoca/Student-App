import 'package:flutter/material.dart';
import 'models/student.dart';
import 'services/api_service.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;
  final ApiService apiService;

  const StudentFormScreen({super.key, this.student, required this.apiService});

  @override
  StudentFormScreenState createState() => StudentFormScreenState();
}

class StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _firstName;
  late String _lastName;
  late String _course;
  late String _year;
  bool _enrolled = false;

  final List<String> _yearOptions = [
    'First Year',
    'Second Year',
    'Third Year',
    'Fourth Year',
    'Fifth Year',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _firstName = widget.student!.firstName;
      _lastName = widget.student!.lastName;
      _course = widget.student!.course;
      _year = widget.student!.year;
      _enrolled = widget.student!.enrolled;
    } else {
      _firstName = '';
      _lastName = '';
      _course = '';
      _year = _yearOptions[0];
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final student = Student(
        id: widget.student?.id ?? 0,
        firstName: _firstName,
        lastName: _lastName,
        course: _course,
        year: _year,
        enrolled: _enrolled,
      );

      try {
        Student? resultStudent;
        if (widget.student == null) {
          // Adding a new student
          resultStudent = await widget.apiService.addStudent(student);
        } else {
          // Updating an existing student
          resultStudent = await widget.apiService.updateStudent(student);
        }

        if (resultStudent != null) {
          Navigator.pop(context, resultStudent);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save student.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Add Student' : 'Edit Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _firstName,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a first name';
                  }
                  return null;
                },
                onSaved: (value) => _firstName = value!,
              ),
              TextFormField(
                initialValue: _lastName,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a last name';
                  }
                  return null;
                },
                onSaved: (value) => _lastName = value!,
              ),
              TextFormField(
                initialValue: _course,
                decoration: const InputDecoration(labelText: 'Course'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a course';
                  }
                  return null;
                },
                onSaved: (value) => _course = value!,
              ),
              DropdownButtonFormField<String>(
                value: _year,
                decoration: const InputDecoration(labelText: 'Year'),
                items: _yearOptions.map((String year) {
                  return DropdownMenuItem<String>(
                    value: year,
                    child: Text(year),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _year = newValue!;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Enrolled'),
                value: _enrolled,
                onChanged: (bool value) {
                  setState(() {
                    _enrolled = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.student == null ? 'Add Student' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
