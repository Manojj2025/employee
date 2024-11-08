import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../bloc/employ_bloc.dart';
import '../widgets/employe_form.dart';

class EmployeeScreen extends StatelessWidget {
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat("d MMM y").format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee List')),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          return state.employees.isEmpty
              ? Center(
                  child: Image.asset(
                    "assets/empty.png",
                    height: 150,
                  ),
                )
              : ListView.builder(
                  itemCount: state.employees.length,
                  itemBuilder: (context, index) {
                    final employee = state.employees[index];

                    return Column(
                      children: [
                        Dismissible(
                          key: Key(employee.id
                              .toString()), // Unique key for each item
                          direction: DismissDirection
                              .endToStart, // Swipe direction (from right to left)
                          onDismissed: (direction) {
                            // Perform deletion when swiped
                            BlocProvider.of<EmployeeBloc>(context)
                                .add(DeleteEmployee(employee.id!));
                            Fluttertoast.showToast(
                              msg:
                                  "Employee Data has been Deleted", // Message to display
                              toastLength:
                                  Toast.LENGTH_SHORT, // Duration of the toast
                              gravity:
                                  ToastGravity.BOTTOM, // Position of the toast
                              timeInSecForIosWeb:
                                  1, // Time in seconds for iOS and web
                              fontSize: 16.0, // Font size
                            );
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: ListTile(
                            title: Text(
                              employee.name,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  employee.role,
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  employee.endDate == null
                                      ? "From ${_formatDate(employee.startDate)}"
                                      : "${_formatDate(employee.startDate)}  - ${_formatDate(employee.endDate)}",
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            onTap: () async {
                              final updatedEmployee = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EmployeeForm(employee: employee)),
                              );
                              if (updatedEmployee != null) {
                                BlocProvider.of<EmployeeBloc>(context)
                                    .add(UpdateEmployee(updatedEmployee));
                              }
                            },
                          ),
                        ),
                        // Add the Divider here after each ListTile
                        const Divider(),
                      ],
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          final newEmployee = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EmployeeForm()),
          );
          if (newEmployee != null) {
            BlocProvider.of<EmployeeBloc>(context)
                .add(AddEmployee(newEmployee));
          }
        },
      ),
    );
  }
}
