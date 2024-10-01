import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<List<Student>> getStudents() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_students.php'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Student.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load students: ${response.statusCode}');
      }
    } on SocketException catch (_) {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Failed to load students: $e');
    }
  }

  Future<Student?> addStudent(Student student) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add_student.php'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(student.toJson()),
      );
      if (response.statusCode == 200) {
        return Student.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add student: ${response.statusCode}');
      }
    } on SocketException catch (_) {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Failed to add student: $e');
    }
  }

  Future<Student?> updateStudent(Student student) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update_student.php'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(student.toJson()),
      );
      if (response.statusCode == 200) {
        return Student.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update student: ${response.statusCode}');
      }
    } on SocketException catch (_) {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Failed to update student: $e');
    }
  }

  Future<void> deleteStudent(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete_student.php?id=$id'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete student: ${response.statusCode}');
      }
    } on SocketException catch (_) {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Failed to delete student: $e');
    }
  }
}
