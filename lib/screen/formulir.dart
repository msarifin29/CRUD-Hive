// ignore_for_file: unused_field, must_be_immutable, avoid_print, use_build_context_synchronously

import 'package:copy/screen/home.dart';
import 'package:copy/service/hive_db.dart';
import 'package:flutter/material.dart';
import '../model/todo_model.dart';

class Formulir extends StatefulWidget {
  Formulir({Key? key, this.todos, this.index}) : super(key: key);

  static const roteName = 'formulir';

  Todo? todos;
  int? index;

  @override
  State<Formulir> createState() => _FormulirState();
}

class _FormulirState extends State<Formulir> {
  final _titleC = TextEditingController();
  final _descriptionC = TextEditingController();

  // read todos
  void getTodos() {
    if (widget.todos != null && widget.index != null) {
      setState(() {
        _titleC.text = widget.todos!.title!;
        _descriptionC.text = widget.todos!.description;
        print('read todo in box');
      });
    }
  }

  void saveTodos() async {
    if (_descriptionC.text.isNotEmpty && _titleC.text.isNotEmpty) {
      var newTodo = Todo(title: _titleC.text, description: _descriptionC.text);
      // update todos
      if (widget.index != null) {
        // await Helper.box.putAt(widget.index!, newTodo);

        await HiveService.instance.updateBox(widget.index!, newTodo);
        print('newTodo is update to box');
      } else {
        // add a new todos
        // await Helper.box.add(newTodo);
        await HiveService.instance.addBox(newTodo);
        print('newTodo is added to box');
      }
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const Home()), (route) => false);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text('Create notes!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ok'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    getTodos();
    super.initState();
  }

  @override
  void dispose() {
    _titleC.clear();
    _descriptionC.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Container(
            width: 100,
            padding: const EdgeInsets.all(5),
            child: RawMaterialButton(
              onPressed: saveTodos,
              fillColor: Theme.of(context).splashColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                'Save',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Title',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              textInputAction: TextInputAction.done,
              controller: _titleC,
              decoration: InputDecoration(
                fillColor: Colors.blue.shade100.withAlpha(75),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              keyboardType: TextInputType.multiline,
              controller: _descriptionC,
              minLines: 10,
              maxLines: 30,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                fillColor: Colors.blue.shade100.withAlpha(75),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
