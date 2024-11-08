// repository/employee_repository.dart

import '../db/database_helper.dart';
import '../models/employe_model.dart';

class EmployeeRepository {
  final EmployeeDatabaseHelper _databaseHelper = EmployeeDatabaseHelper();

  Future<int> addEmployee(Employee employee) =>
      _databaseHelper.insertEmployee(employee);

  Future<List<Employee>> getEmployees() => _databaseHelper.fetchEmployees();

  Future<int> updateEmployee(Employee employee) =>
      _databaseHelper.updateEmployee(employee);

  Future<int> deleteEmployee(int id) => _databaseHelper.deleteEmployee(id);
}
