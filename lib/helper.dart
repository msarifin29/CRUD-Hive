import 'package:copy/model/todo_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Helper {
  static var box = Hive.box<Todo>('todo');
}