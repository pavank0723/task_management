import 'package:sqflite/sqflite.dart';
import 'package:task_management/model/model.dart';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocalDBHelper {
  static final LocalDBHelper instance = LocalDBHelper._init();
  static Database? _database;

  LocalDBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Increment the version
      onCreate: _createDB,
      onUpgrade: _upgradeDB, // Add the upgrade logic
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ToDos (
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        dueDate TEXT,
        priority INTEGER,
        isCompleted INTEGER,
        isSync INTEGER,
        email TEXT
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE ToDos
        ADD COLUMN isSync INTEGER
      ''');
    }
  }

  Future<void> insertToDo(ToDoModel task) async {
    final db = await instance.database;
    await db.insert('ToDos', task.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateToDo(ToDoModel task) async {
    final db = await instance.database;
    await db.update(
      'ToDos',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> toggleToDoCompletion(String id) async {
    final db = await instance.database;
    final currentToDo = await db.query(
      'ToDos',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (currentToDo.isNotEmpty) {
      final isCompleted = currentToDo.first['isCompleted'] as int;
      final newStatus = isCompleted == 1 ? 0 : 1; // Toggle completion status

      await db.update(
        'ToDos',
        {'isCompleted': newStatus},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  Future<void> deleteToDo(String id) async {
    final db = await instance.database;
    await db.delete(
      'ToDos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> syncFirestoreWithSQLite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // No user is logged in

    final email = user.email;
    final firestoreToDo = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('todos')
        .get();

    final firestoreToDoList = firestoreToDo.docs
        .map((doc) => ToDoModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    final db = await instance.database;
    final localToDo = await getToDo();

    for (var firestoreToDo in firestoreToDoList) {
      final existingToDo = localToDo.firstWhere(
        (task) => task.id == firestoreToDo.id,
        orElse: () => ToDoModel(
            id: '',
            title: '',
            description: '',
            dueDate: '',
            priority: 0,
            isCompleted: 0,
            isSync: 0,
            email: ''),
      );

      if (existingToDo.id == '') {
        await insertToDo(firestoreToDo);
      } else {
        await updateToDo(firestoreToDo);
      }
    }
  }

  Future<List<ToDoModel>> getToDo() async {
    final db = await instance.database;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return [];

    final toDo = await db.query(
      'ToDos',
      where: 'email = ?',
      whereArgs: [user.email],
    );
    return toDo.map((map) => ToDoModel.fromJson(map)).toList();
  }
}
