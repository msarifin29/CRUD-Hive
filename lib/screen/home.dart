// ignore_for_file: avoid_print

import 'package:copy/screen/formulir.dart';
import 'package:copy/service/hive_db.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../model/todo_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const roteName = 'home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isDarkMode = false;
  List<Todo> todos = [];

  void getTodoList() {
    var todoList = HiveService().getDB();
    setState(() {
      // todos = Helper.box.values.toList();
      todos = todoList.values.toList();
    });
  }

  themes() async {
    isDarkMode = HiveService.instance.isDarkTheme(false);
    if (isDarkMode) {
      await HiveService.instance.currentTheme(false);
    } else {
      HiveService.instance.currentTheme(true);
    }
  }

  @override
  void initState() {
    getTodoList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Todo List',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: themes,
            icon: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: isDarkMode ? Colors.black : Colors.white,
              ),
            ),
          ),
          // Switch(
          //   value: HiveService.instance.isDarkTheme(false),
          //   onChanged: (val) {
          //     HiveService.instance.currentTheme(val);
          //   },
          // ),
        ],
      ),
      body: ValueListenableBuilder<Box>(
        valueListenable: HiveService.instance.getDB().listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return Center(
              child: Text(
                'No Activity',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }
          return CustomListTile(todos: todos);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Formulir(),
            ),
          );
        },
        child: const Icon(
          Icons.mode_edit_sharp,
        ),
      ),
    );
  }
}

class CustomListTile extends StatefulWidget {
  const CustomListTile({super.key, required this.todos});
  final List<Todo> todos;

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  // delete todos
  void deleteTodos(int index) {
    // Helper.box.deleteAt(index);
    HiveService.instance.deleteBox(index);
    setState(() {
      widget.todos.removeAt(index);
      print('todos is deleted from box');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.todos.length,
      itemBuilder: (ctx, i) {
        return Dismissible(
          key: ValueKey(widget.todos[i]),
          background: Container(
            alignment: AlignmentDirectional.centerEnd,
            color: Colors.red,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          onDismissed: (direction) => deleteTodos(i),
          direction: DismissDirection.endToStart,
          movementDuration: const Duration(milliseconds: 1000),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Card(
              color: Theme.of(context).cardColor,
              elevation: 5,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[400],
                  child: Text(
                    widget.todos[i].title![0],
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                title: Text(
                  widget.todos[i].title!,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                subtitle: Text(
                  widget.todos[i].description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Formulir(
                      todos: widget.todos[i],
                      index: i,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
