// ignore_for_file: unused_field, must_be_immutable, avoid_print, use_build_context_synchronously

import 'package:copy/helper.dart';
import 'package:copy/screen/home.dart';
import 'package:flutter/material.dart';

import '../model/todo_model.dart';

class Formulir extends StatefulWidget {
  Formulir({Key? key, this.todos, this.index}) : super(key: key);

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
        await Helper.box.putAt(widget.index!, newTodo);
        print('newTodo is update to box');
      } else {
        // add a new todo
        await Helper.box.add(newTodo);
        print('newTodo is added to box');
      }
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const Home()), (route) => false);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text('Are you sure!'),
          actions: [ TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('no'),
            ),
            TextButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const Home()),
                  (route) => false),
              child: const Text('yes'),
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
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Title',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              textInputAction: TextInputAction.done,
              controller: _titleC,
              decoration: InputDecoration(
                hintText: 'Enter title',
                hintStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
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
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Description',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
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
                hintText: 'Write some words',
                hintStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
          Expanded(
            child: Align(
              alignment: FractionalOffset.centerRight,
              child: Container(
                height: 60,
                width: 150,
                padding: const EdgeInsets.only(right: 20.0),
                child: RawMaterialButton(
                  onPressed: saveTodos,
                  fillColor: Colors.blueAccent.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child:const Text(
                    'Save',
                    style:TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
