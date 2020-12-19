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
      home: MyHomePage(title: 'SQLITE Demo'),
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
      body: FutureBuilder(
        future: db.initDB(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _showList(context);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
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
                var task = Task(text);
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
                ListTile(
                  title: Text(task.name),
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
}
