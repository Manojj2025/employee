import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/employe_model.dart';

class EmployeeDatabaseHelper {
  static final EmployeeDatabaseHelper _instance =
      EmployeeDatabaseHelper._internal();
  static Database? _database;

  EmployeeDatabaseHelper._internal();

  factory EmployeeDatabaseHelper() => _instance;

  // Database initialization
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Initialize the database
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'employee2.db');

    // Open the database with schema creation if it's the first time
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print('Creating employees table...');
        // Create the 'employees' table
        await db.execute('''
          CREATE TABLE employees (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            role TEXT NOT NULL,
            startDate TEXT NOT NULL,
            endDate TEXT
          )
        ''');
      },
      onOpen: (db) {
        print('Database opened');
      },
    );
  }

  // Insert a new employee
  Future<int> insertEmployee(Employee employee) async {
    final db = await database;
    return await db.insert(
      'employees', // Use 'employees' as the table name
      employee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all employees
  Future<List<Employee>> fetchEmployees() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('employees'); // Use 'employees' as the table name

    return List.generate(maps.length, (i) {
      return Employee.fromMap(maps[i]);
    });
  }

  // Update an existing employee
  Future<int> updateEmployee(Employee employee) async {
    final db = await database;
    return await db.update(
      'employees', // Use 'employees' as the table name
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  // Delete an employee by ID
  Future<int> deleteEmployee(int id) async {
    final db = await database;
    return await db.delete(
      'employees', // Use 'employees' as the table name
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Optionally, you can clear the database (useful in development)
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('employees'); // Use 'employees' as the table name
  }

  // Optionally, to handle database version upgrade in future changes
  // onUpgrade can be used to handle schema changes in newer versions of your database
  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Add your migration code here if needed
      print("Upgrading database from version $oldVersion to $newVersion");
    }
  }
}
