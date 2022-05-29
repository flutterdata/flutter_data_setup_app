// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $TodoLocalAdapter on LocalAdapter<Todo> {
  static final Map<String, RelationshipMeta> _kTodoRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kTodoRelationshipMetas;

  @override
  Todo deserialize(map) {
    map = transformDeserialize(map);
    return _$TodoFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$TodoToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _todosFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $TodoHiveLocalAdapter = HiveLocalAdapter<Todo> with $TodoLocalAdapter;

class $TodoRemoteAdapter = RemoteAdapter<Todo> with NothingMixin;

final internalTodosRemoteAdapterProvider = Provider<RemoteAdapter<Todo>>(
    (ref) => $TodoRemoteAdapter(
        $TodoHiveLocalAdapter(ref.read), InternalHolder(_todosFinders)));

final todosRepositoryProvider =
    Provider<Repository<Todo>>((ref) => Repository<Todo>(ref.read));

extension TodoDataRepositoryX on Repository<Todo> {}

extension TodoRelationshipGraphNodeX on RelationshipGraphNode<Todo> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool? ?? false,
    );

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'completed': instance.completed,
    };
