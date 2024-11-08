class Employee {
  final int? id;
  final String name;
  final String role;
  final DateTime startDate;
  final DateTime? endDate;

  Employee({
    this.id,
    required this.name,
    required this.role,
    required this.startDate,
    this.endDate,
  });

  // Convert Employee to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'startDate': startDate.toIso8601String(), // Convert DateTime to String
      'endDate':
          endDate?.toIso8601String(), // Convert DateTime to String (nullable)
    };
  }

  // Convert Map to Employee (parse DateTime)
  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      role: map['role'],
      startDate:
          DateTime.parse(map['startDate']), // Convert String back to DateTime
      endDate: map['endDate'] != null
          ? DateTime.parse(
              map['endDate']) // Convert String back to DateTime (nullable)
          : null,
    );
  }
}
