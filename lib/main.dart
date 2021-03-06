import 'package:flutter/material.dart';
import 'package:sqlite_tutorial/database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Add tasks below'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TaskDataBase db = TaskDataBase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12),
        child: FutureBuilder(
          future: db.initDB(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _showList(context);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _addTask() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                icon: Icon(Icons.add_circle_outline),
              ),
              onSubmitted: (text) {
                var task = Task(null, text, false);
                //No aparecía por esto, AAAAAAAAAAAAAAAAAAAAAAAAAAH!!!
                setState(() {
                  db.insert(task);
                });

                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  _showList(BuildContext context) {
    return FutureBuilder(
      future: db.getAllTasks(),
      builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
        //Comprobar si hay registros
        if (snapshot.hasData) {
          return ListView(
            children: <Widget>[
              for (Task task in snapshot.data)
                Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                      color: task.completed
                          ? Color(0xff65d459)
                          : Color(0xffe63030),
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    onTap: () {
                      _toggleTask(task);
                    },
                    onLongPress: () {
                      _deleteTask(task);
                    },
                    leading: Icon(
                      task.completed
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: task.completed ? Colors.black54 : Colors.white,
                    ),
                    title: Text(
                      task.name,
                      style: TextStyle(
                          color: task.completed ? Colors.black54 : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                )
            ],
          );
        } else {
          return Center(
            child: Text('Add a Task'),
          );
        }
      },
    );
  }

  void _toggleTask(Task task) async {
    task.completed = !task.completed;
    await db.updateTask(task);
    setState(() {});
  }

  void _deleteTask(Task task) async {
    await db.deleteTask(task);
    setState(() {});
  }
}
