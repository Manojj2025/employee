import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/employe_model.dart';

class EmployeeForm extends StatefulWidget {
  final Employee? employee;

  const EmployeeForm({super.key, this.employee});

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _startdate = TextEditingController();
  final _enddate = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedRole;

  // Calendar settings
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  final List<String> _roles = [
    'Product Designer',
    'Flutter Developer',
    'QA Tester',
    'Product Owner'
  ];

  // Function to format the date as "5 Sep 2024"
  String _formatDate(DateTime? date) {
    if (date == null) return 'Not Selected';
    return DateFormat("d MMM y").format(date);
  }

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _nameController.text = widget.employee!.name;
      _selectedRole = widget.employee!.role;
      _startDate = DateTime.parse(widget.employee!.startDate.toString());
      _endDate = widget.employee!.endDate != null
          ? DateTime.parse(widget.employee!.endDate.toString())
          : null;
      _startdate.text = _formatDate(_startDate);
      _enddate.text = _formatDate(_endDate);
    }
  }

  void _showRoleBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: ListView.builder(
            itemCount: _roles.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Center(
                    child: Text(
                  _roles[index],
                  textAlign: TextAlign.center,
                )),
                onTap: () {
                  setState(() {
                    _selectedRole = _roles[index];
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  void _showCalendarDialog(bool isStartDate, TextEditingController controller) {
    // Set the default date to today if _startDate or _endDate is null
    setState(() {
      if (isStartDate && _startDate == null) {
        _startDate = DateTime.now();
        controller.text = _formatDate(_startDate);
      } else if (!isStartDate && _endDate == null) {
        _endDate = DateTime.now();
        controller.text = _formatDate(_endDate);
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              backgroundColor: Colors.white,
              child: SizedBox(
                height: 500,
                child: Column(
                  children: [
                    Expanded(
                      child: TableCalendar(
                        firstDay: isStartDate
                            ? DateTime(2000)
                            : (_startDate ?? DateTime(2000)),
                        lastDay: DateTime(2100),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month'
                        },
                        selectedDayPredicate: (day) {
                          return isStartDate
                              ? (_startDate != null &&
                                  day.isAtSameMomentAs(_startDate!))
                              : (_endDate != null &&
                                  day.isAtSameMomentAs(_endDate!));
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          // Set selected day and refresh the calendar instantly
                          setState(() {
                            _focusedDay = focusedDay;
                            if (isStartDate) {
                              _startDate = selectedDay;
                              _startdate.text = _formatDate(_startDate);
                              _endDate = null;
                              _enddate.clear();
                            } else {
                              _endDate = selectedDay;
                              _enddate.text = _formatDate(_endDate);
                            }
                          });
                        },
                        daysOfWeekStyle: const DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          weekendStyle: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        calendarStyle: const CalendarStyle(
                          defaultTextStyle: TextStyle(color: Colors.black),
                          weekendTextStyle: TextStyle(color: Colors.black),
                          todayTextStyle: TextStyle(color: Colors.white),
                          todayDecoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          selectedTextStyle: TextStyle(color: Colors.white),
                          selectedDecoration: BoxDecoration(
                            color: Colors
                                .blue, // Highlight color for selected date
                            shape: BoxShape.circle,
                          ),
                          disabledTextStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0, bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.white),
                            onPressed: () {
                              Navigator.pop(
                                  context); // Close dialog without saving
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(
                                  context); // Close dialog with saved date
                              if (isStartDate) {
                                controller.text = _formatDate(_startDate);
                              } else {
                                controller.text = _formatDate(_endDate);
                              }
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.employee == null ? 'Add Employee' : 'Update Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.black, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Employee Name',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade500, fontSize: 15),
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide:
                        BorderSide(color: Colors.grey.shade400, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide:
                        BorderSide(color: Colors.grey.shade400, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide:
                        BorderSide(color: Colors.grey.shade400, width: 1.5),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a name'
                    : null,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _showRoleBottomSheet,
                child: InputDecorator(
                  decoration: InputDecoration(
                    hintText: 'Role',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide:
                          BorderSide(color: Colors.grey.shade400, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide:
                          BorderSide(color: Colors.grey.shade400, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide:
                          BorderSide(color: Colors.grey.shade400, width: 1.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.work_outline, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            _selectedRole ?? 'Select Role',
                            style: TextStyle(
                                color: _selectedRole == null
                                    ? Colors.grey.shade600
                                    : Colors.black,
                                fontSize: 15),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.blue),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _startdate,
                      readOnly: true,
                      onTap: () => _showCalendarDialog(true, _startdate),
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: Colors.grey.shade500, fontSize: 15),
                        hintText: 'Start Date',
                        prefixIcon: const Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                              color: Colors.grey.shade400, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                              color: Colors.grey.shade400, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                              color: Colors.grey.shade400, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _enddate,
                      readOnly: true,
                      onTap: () => _showCalendarDialog(false, _enddate),
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: Colors.grey.shade500, fontSize: 15),
                        hintText: 'No Date',
                        prefixIcon: const Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                              color: Colors.grey.shade400, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                              color: Colors.grey.shade400, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                              color: Colors.grey.shade400, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Wrap in Expanded to prevent overflow
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Wrap in Expanded to prevent overflow
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_startDate == null || _selectedRole == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please complete all fields'),
                        ),
                      );
                      return;
                    }

                    final employee = Employee(
                      id: widget.employee?.id,
                      name: _nameController.text,
                      role: _selectedRole!,
                      startDate: _startDate!,
                      endDate: _endDate,
                    );

                    Navigator.pop(context, employee);
                  }
                },
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
