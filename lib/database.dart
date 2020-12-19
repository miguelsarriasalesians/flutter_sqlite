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
      'my_db.db',
      version: 1,
      //Se ejecuta cuando se cree este archivo por primera vez
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE tasks(id INTEGER PRIMARY KEY, name TEXT NOT NULL);");
      },
    );
  }

  //Introducir tareas en la base de datos
  insert(Task task) {
    _db.insert("tasks", task.toMap());
  }

  //Obtener todas las tareas
  Future<List<Task>> getAllTasks() async {
    //La funcion _db.query devuelve una List<Map<String, dynamic>>
    List<Map<String, dynamic>> results = await _db.query("tasks");
    List<Task> taskList = results.map((map) => Task.fromMap(map));
    return taskList;
  }
}
