// ignore_for_file: avoid_print

import 'package:copy/helper.dart';
import 'package:copy/screen/formulir.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../model/todo_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Todo> todos = [];

  void getTodoList() {
    setState(() {
      todos = Helper.box.values.toList();
    });
  }

  void deleteTodos(
    int index,
  ) {
    Helper.box.deleteAt(index);
    setState(() {
      todos.removeAt(index);
      print('todos is deleted from box');
    });
  }

  @override
  void initState() {
    getTodoList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Hive'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<Todo>>(
        valueListenable: Helper.box.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No Activity',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (ctx, i) {
              return Dismissible(
                key: ValueKey(todos[i]),
                background: Container(alignment: AlignmentDirectional.centerEnd,
                  color: Colors.red,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) => deleteTodos(i),direction: DismissDirection.endToStart,
                movementDuration:const Duration(milliseconds: 1000),
                resizeDuration: const Duration(milliseconds: 1000),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Card(
                    elevation: 5,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent.shade200,
                        child: Text(
                          todos[i].title![0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        todos[i].title!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        todos[i].description,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      // trailing: IconButton(
                      //   onPressed: () => deleteTodos(i),
                      //   icon: const Icon(
                      //     Icons.delete,
                      //     color: Colors.red,
                      //   ),
                      // ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Formulir(
                            todos: todos[i],
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
        },
      ),
      floatingActionButton: FloatingActionButton(
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
