import 'package:bloc/bloc.dart';
import '../../data/models/employe_model.dart';
import '../../data/repo/remploye_repo.dart';

class EmployeeCubit extends Cubit<List<Employee>> {
  final EmployeeRepository _repository;

  EmployeeCubit(this._repository) : super([]);

  void fetchEmployees() async {
    final employees = await _repository.getEmployees();
    emit(employees);
  }

  void addEmployee(Employee employee) async {
    await _repository.addEmployee(employee);
    fetchEmployees();
  }

  void updateEmployee(Employee employee) async {
    await _repository.updateEmployee(employee);
    fetchEmployees();
  }

  void deleteEmployee(int id) async {
    await _repository.deleteEmployee(id);
    fetchEmployees();
  }
}
