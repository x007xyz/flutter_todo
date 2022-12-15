import 'package:flutter/material.dart';
import 'package:learn_flutter/bus.dart';

import 'main.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key, required this.list});

  final TodoList list;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${list.name}"),
      ),
      body: TodoListWidget(items: list.items),
    );
  }
}

class TodoListWidget extends StatefulWidget {
  final List<TodoItem> items;
  TodoListWidget({ required this.items });
  @override
  State<StatefulWidget> createState() {
    return _TodoListState();
  }
}

class TodoItem {
  String name;
  bool isComplete;
  TodoItem({required this.name, required this.isComplete});
}

class _TodoListState extends State<TodoListWidget> {
  List<TodoItem> _todoItems = [];

  TextEditingController _inputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: _inputController,
                      decoration: InputDecoration(hintText: "新增待办"),
                    )),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // 新增todoItem
                            _todoItems.add(TodoItem(
                                name: _inputController.text,
                                isComplete: false));
                            _inputController.text = "";
                          });
                        },
                        child: Text("新增"))
                  ],
                ),
                Expanded(
                    child: ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          final item = _todoItems[index];
                          return ListTile(
                            leading: Checkbox(
                              value: item.isComplete,
                              onChanged: (checked) {
                                print("checkbox is " + checked.toString());
                                setState(() {
                                  _todoItems[index].isComplete = checked!;
                                });
                              },
                            ),
                            title: Text("${item.name}",
                                style: item.isComplete
                                    ? TextStyle(
                                        decoration: TextDecoration.lineThrough)
                                    : null),
                            trailing: IconButton(
                                icon: Icon(Icons.delete_outline),
                                onPressed: () {
                                  setState(() {
                                    _todoItems.removeAt(index);
                                  });
                                },
                                color: Colors.redAccent),
                            contentPadding: EdgeInsets.all(0.0),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(color: Colors.black45);
                        },
                        itemCount: _todoItems.length))
              ],
            )));
  }

  @override
  void initState() {
    super.initState();
    _todoItems = widget.items;
  }

  @override
  void dispose() {
    super.dispose();
    bus.emit("updateList", _todoItems);
  }
}
