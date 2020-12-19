import 'dart:async';

import 'package:sqflite/sqflite.dart';

class Task {
  //Le quitamos el final para que en el constructor Task.fromMap no pete
  String name;

  Task(this.name);

  Map<String, dynamic> toMap() {
    return {
      "name": name,
    };
  }

  //Constructor
  Task.fromMap(Map<String, dynamic> map) {
    name = map['name'];
  }
}

class TaskDataBase {
  Database _db;

  //Abrir la base de datos
  initDB() async {
    _db = await openDatabase(
      'my_db2.db',
      version: 1,
      //Se ejecuta cuando se cree este archivo por primera vez
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE tasks(id INTEGER PRIMARY KEY, name TEXT NOT NULL);");
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
}
