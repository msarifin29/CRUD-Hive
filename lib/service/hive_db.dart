// ignore_for_file: unused_element

import 'package:hive_flutter/hive_flutter.dart';

import '../model/todo_model.dart';

class HiveService {
  static final HiveService instance = HiveService._internal();

  factory HiveService() {
    return instance;
  }

  HiveService._internal();

  // get Todo box
  Box<Todo> getDB() => Hive.box<Todo>('todo');

  // get theme box
  Box<dynamic> getThemeMode() => Hive.box('darkMode');

  bool isDarkTheme(bool value) {
    return Hive.box('darkMode').get('darkMode', defaultValue: value);
  }

  // Update theme mode
  Future<void> currentTheme(bool value) async {
    await Hive.box('darkMode').put('darkMode', value);
  }

  Future<void> _createBox() async {
    // Todo box
    await Hive.openBox<Todo>('todo');
    // Theme box
    await Hive.openBox('darkMode');
  }

  // Delete from box
  Future<void> deleteBox(int index) async {
    await Hive.box<Todo>('todo').deleteAt(index);
  }

  // Update to the box
  Future<void> updateBox(int index, Todo newTodo) async {
    await Hive.box<Todo>('todo').putAt(index, newTodo);
  }

  // Added to the box
  Future<void> addBox(Todo newTodo) async {
    await Hive.box<Todo>('todo').add(newTodo);
  }

  void _registerAdapter() {
    Hive.registerAdapter<Todo>(TodoAdapter());
  }

  Future init() async {
    // Initializing the hive
    await Hive.initFlutter();
    _registerAdapter();
    await _createBox();
  }
}
