import 'dart:async';

import 'package:sqflite/sqflite.dart';

class Task {
  //Le quitamos el final para que en el constructor Task.fromMap no pete
  int id;
  String name;
  bool completed;
  Task(this.id, this.name, this.completed);

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "completed": completed ? 1 : 0,
    };
  }

  //Constructor
  Task.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    completed = map['completed'] == 1;
    id = map['id'];
  }
}

class TaskDataBase {
  Database _db;

  //Abrir la base de datos
  initDB() async {
    _db = await openDatabase(
      'my_db2.db',
      version: 2,
      //Se ejecuta cuando se cree este archivo por primera vez
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE tasks(id INTEGER PRIMARY KEY, name TEXT NOT NULL, completed INTEGERE DEFAULT 0);");
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion == 1) {
          db.execute(
              "ALTER TABLE tasks ADD COLUMN completed INTEGER DEFAULT 0;");
        }
      },
    );
    print("DB INITIALIZED");
  }

  //Introducir tareas en la base de datos
  insert(Task task) async {
    await _db.insert("tasks", task.toMap());
  }

  //Obtener todas las tareas de la base de datos
  Future<List<Task>> getAllTasks() async {
    //La funcion _db.query devuelve una List<Map<String, dynamic>>
    List<Map<String, dynamic>> results = await _db.query("tasks");
    //La funcion embebida fromMap genera un objeto Task a partir del mapa, genera tantas Task como mapas en la lista results
    List<Task> taskList = results.map((map) => Task.fromMap(map)).toList();
    print("Got: ${results.length}");
    return taskList;
  }

  Future updateTask(Task task) async {
    _db.update("tasks", task.toMap(), where: "id = ?", whereArgs: [task.id]);
  }

  Future deleteTask(Task task) async {
    _db.delete("tasks", where: "id = ?", whereArgs: [task.id]);
  }
}
