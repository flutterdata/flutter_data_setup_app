// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) {
  return Todo(
    id: json['id'] as int,
    title: json['title'] as String,
    completed: json['completed'] as bool,
  );
}

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'completed': instance.completed,
    };

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, non_constant_identifier_names

mixin $TodoLocalAdapter on LocalAdapter<Todo> {
  @override
  Map<String, Map<String, Object>> relationshipsFor([Todo model]) => {};

  @override
  Todo deserialize(map) {
    for (final key in relationshipsFor().keys) {
      map[key] = {
        '_': [map[key], !map.containsKey(key)],
      };
    }
    return _$TodoFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model) => _$TodoToJson(model);
}

// ignore: must_be_immutable
class $TodoHiveLocalAdapter = HiveLocalAdapter<Todo> with $TodoLocalAdapter;

class $TodoRemoteAdapter = RemoteAdapter<Todo> with NothingMixin;

//

final todoLocalAdapterProvider =
    Provider<LocalAdapter<Todo>>((ref) => $TodoHiveLocalAdapter(ref));

final todoRemoteAdapterProvider = Provider<RemoteAdapter<Todo>>(
    (ref) => $TodoRemoteAdapter(ref.read(todoLocalAdapterProvider)));

final todoRepositoryProvider =
    Provider<Repository<Todo>>((ref) => Repository<Todo>(ref));

final _watchTodo = StateNotifierProvider.autoDispose
    .family<DataStateNotifier<Todo>, WatchArgs<Todo>>((ref, args) {
  return ref.watch(todoRepositoryProvider).watchOne(args.id,
      remote: args.remote,
      params: args.params,
      headers: args.headers,
      alsoWatch: args.alsoWatch);
});

AutoDisposeStateNotifierProvider<DataStateNotifier<Todo>> watchTodo(dynamic id,
    {bool remote = true,
    Map<String, dynamic> params = const {},
    Map<String, String> headers = const {},
    AlsoWatch<Todo> alsoWatch}) {
  return _watchTodo(WatchArgs(
      id: id,
      remote: remote,
      params: params,
      headers: headers,
      alsoWatch: alsoWatch));
}

final _watchTodos = StateNotifierProvider.autoDispose
    .family<DataStateNotifier<List<Todo>>, WatchArgs<Todo>>((ref, args) {
  ref.maintainState = false;
  return ref.watch(todoRepositoryProvider).watchAll(
      remote: args.remote,
      params: args.params,
      headers: args.headers,
      filterLocal: args.filterLocal,
      syncLocal: args.syncLocal);
});

AutoDisposeStateNotifierProvider<DataStateNotifier<List<Todo>>> watchTodos(
    {bool remote, Map<String, dynamic> params, Map<String, String> headers}) {
  return _watchTodos(
      WatchArgs(remote: remote, params: params, headers: headers));
}

extension TodoX on Todo {
  /// Initializes "fresh" models (i.e. manually instantiated) to use
  /// [save], [delete] and so on.
  ///
  /// Requires a `[Reader read]` (unless using GetIt).
  ///
  /// Can be obtained via `context.read`, `ref.read`, `container.read`
  Todo init([Reader read]) {
    final repository = internalLocatorFn(todoRepositoryProvider, read);
    return repository.remoteAdapter.initializeModel(this, save: true);
  }
}
