// blocs/employee_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/employe_model.dart';
import '../repo/remploye_repo.dart';

abstract class EmployeeEvent {}

class LoadEmployees extends EmployeeEvent {}

class AddEmployee extends EmployeeEvent {
  final Employee employee;
  AddEmployee(this.employee);
}

class UpdateEmployee extends EmployeeEvent {
  final Employee employee;
  UpdateEmployee(this.employee);
}

class DeleteEmployee extends EmployeeEvent {
  final int id;
  DeleteEmployee(this.id);
}

class EmployeeState {
  final List<Employee> employees;
  EmployeeState(this.employees);
}

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository repository;

  EmployeeBloc(this.repository) : super(EmployeeState([])) {
    on<LoadEmployees>((event, emit) async {
      final employees = await repository.getEmployees();
      emit(EmployeeState(employees));
    });
    on<AddEmployee>((event, emit) async {
      await repository.addEmployee(event.employee);
      add(LoadEmployees());
    });
    on<UpdateEmployee>((event, emit) async {
      await repository.updateEmployee(event.employee);
      add(LoadEmployees());
    });
    on<DeleteEmployee>((event, emit) async {
      await repository.deleteEmployee(event.id);
      add(LoadEmployees());
    });
  }
}
