import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable()
@DataRepository([])
class Todo extends DataModel<Todo> {
  @override
  final int id;
  final String title;
  final bool completed;

  Todo({required this.id, required this.title, this.completed = false});
}
