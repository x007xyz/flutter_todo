import 'package:flutter/material.dart';
import 'package:learn_flutter/todo.dart';

import 'bus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class TodoList {
  String name;
  List<TodoItem> items;
  TodoList({ required this.name, required this.items });
}

class _MyHomePageState extends State<MyHomePage> {

  List<TodoList> _todoList = [];
  late int _selectedTodoListIndex;

  TextEditingController _nameController = TextEditingController();

  Future<String?> showNewConfirmDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("新增"),
            content: TextField(
              autofocus: true,
              decoration:
                  InputDecoration(labelText: "新增待办清单名称", hintText: "清单名称"),
              controller: _nameController,
              onChanged: (v) {
                print("onChange: $v");
              },
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("取消")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(_nameController.text);
                    _nameController.text = "";
                  },
                  child: Text("确认"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            final item = _todoList[index];
            return ListTile(
              title: Text("${item.name}（${item.items.length}）"),
              trailing: TextButton(
                child: Text("删除", style: TextStyle(color: Colors.red)),
                onPressed: () {
                  setState(() {
                    _todoList.removeAt(index);
                  });
                },
              ),
              onTap: () {
                _selectedTodoListIndex = index;
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TodoPage(list: item);
                }));
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return index % 2 == 0
                ? Divider(height: 1, color: Colors.cyan)
                : Divider(height: 1, color: Colors.amber);
          },
          itemCount: _todoList.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? data = await showNewConfirmDialog();
          if (data == null) {
            print("取消删除");
          } else {
            print("新增清单：" + data);
            setState(() {
              _todoList.add(TodoList(name: data, items: []));
            });
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void initState() {
    super.initState();

    bus.on("updateList", (items) {
      Future.delayed(Duration(milliseconds: 200)).then((value) {
        setState(() {
          _todoList[_selectedTodoListIndex].items = items;
        });
      });
    });
  }
}
