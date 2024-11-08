import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'data/bloc/employ_bloc.dart';
import 'data/presentation/screens/employe_screen.dart';
import 'data/repo/remploye_repo.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Instantiate the EmployeeRepository
  final EmployeeRepository employeeRepository = EmployeeRepository();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'Employee Manager',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.blue,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            scaffoldBackgroundColor:
                Colors.white, // Set the global background color to white
            textTheme: const TextTheme(
              bodySmall: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(color: Colors.white),
              titleMedium: TextStyle(color: Colors.white),
              labelLarge: TextStyle(color: Colors.white),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Primary color for buttons
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    Colors.white, // White text color for TextButton
              ),
            ),
          ),
          home: child,
        );
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<EmployeeBloc>(
            create: (context) => EmployeeBloc(employeeRepository)
              ..add(LoadEmployees()), // Load employees on startup
          ),
        ],
        child: MaterialApp(
          title: 'Employee Manager',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.blue,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            scaffoldBackgroundColor:
                Colors.white, // Set the global background color to white
            textTheme: const TextTheme(
              bodySmall: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(color: Colors.white),
              titleMedium: TextStyle(color: Colors.white),
              labelLarge: TextStyle(color: Colors.white),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Primary color for buttons
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor:
                    Colors.white, // White text color for TextButton
              ),
            ),
          ),
          home: EmployeeScreen(), // The main screen for managing employees
        ),
      ),
    );
  }
}
