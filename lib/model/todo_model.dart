import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)

class Todo {
@HiveField(0)
String? title;

@HiveField(1)
String description;

Todo({this.title, required this.description});
}