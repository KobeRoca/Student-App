class Student {
  final int id;
  final String firstName;
  final String lastName;
  final String course;
  final String year;
  final bool enrolled;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.course,
    required this.year,
    required this.enrolled,
  });

  // Factory constructor to create a Student object from JSON data
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,  // Default to 0 if id is null
      firstName: json['firstName'] ?? '',  // Default to empty string if firstName is null
      lastName: json['lastName'] ?? '',  // Default to empty string if lastName is null
      course: json['course'] ?? '',  // Default to empty string if course is null
      year: json['year'] ?? '1',  // Default to '1' (First Year) if year is null
      enrolled: json['enrolled'] == 1 || json['enrolled'] == true,  // Handle boolean or integer representation
    );
  }

  // Convert a Student object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'course': course,
      'year': year,
      'enrolled': enrolled ? 1 : 0,  // Convert boolean to integer (1 or 0)
    };
  }
}
