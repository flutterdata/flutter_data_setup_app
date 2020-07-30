import 'package:flutter/material.dart';
import 'package:flutter_data_setup_app/todo.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart' as p;

import 'main.data.dart';

void main() {
  runApp(RiverpodTodoApp());
  // runApp(ProviderTodoApp());
  // runApp(GetItTodoApp());
}

final initializerProvider = FutureProvider<bool>((ref) async {
  await ref.read(repositoryInitializerProvider());
  final repository = ref.read(todoRepositoryProvider);
  await ref.read(sessionProvider).initialize(repository);
  return true;
});

class RiverpodTodoApp extends StatelessWidget {
  @override
  Widget build(context) {
    return ProviderScope(
      overrides: [
        configureRepositoryLocalStorage(clear: false),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: Consumer((context, read) {
              // could simply use:
              // read(repositoryInitializerProvider()).when()
              return read(initializerProvider).when(
                data: (_) {
                  // Flutter Data repositories are ready at this point!
                  final repository = read(todoRepositoryProvider);
                  return GestureDetector(
                    onDoubleTap: () async {
                      print(
                          (await repository.findOne(1, remote: false))?.title);
                      final todo = await Todo(id: 1, title: 'blah')
                          .init(context)
                          .save(remote: false);
                      print(keyFor(todo));
                    },
                    child:
                        Text('Hello Flutter Data with Riverpod! $repository'),
                  );
                },
                loading: () {
                  return const CircularProgressIndicator();
                },
                error: (err, _) {
                  return Text('An error occured: $err');
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}

class ProviderTodoApp extends StatelessWidget {
  @override
  Widget build(context) {
    return p.MultiProvider(
      providers: [
        ...repositoryProviders(clear: true),
        p.ProxyProvider<Repository<Todo>, SessionService>(
          lazy: false,
          create: (_) => SessionService(),
          update: (context, repository, service) {
            return service..initialize(repository);
          },
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: Builder(
              builder: (context) {
                if (context.watch<RepositoryInitializer>().isLoading) {
                  // optionally also check
                  // context.watch<SessionService>.repository != null
                  return const CircularProgressIndicator();
                }
                final repository = context.watch<Repository<Todo>>();
                return GestureDetector(
                  onDoubleTap: () async {
                    print((await repository.findOne(1, remote: false))?.title);
                    final todo = await Todo(id: 1, title: 'blah')
                        .init(context)
                        .save(remote: false);
                    print(keyFor(todo));
                  },
                  child: Text('Hello Flutter Data with Provider! $repository'),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class GetItTodoApp extends StatelessWidget {
  @override
  Widget build(context) {
    GetIt.instance.registerRepositories(clear: false);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder(
            future: GetIt.instance.allReady(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              final repository = GetIt.instance.get<Repository<Todo>>();
              return GestureDetector(
                onDoubleTap: () async {
                  print((await repository.findOne(1, remote: false))?.title);
                  final todo = await Todo(id: 1, title: 'blah')
                      .init(context)
                      .save(remote: false);
                  print(keyFor(todo));
                },
                child: Text('Hello Flutter Data with GetIt! $repository'),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SessionService {
  Repository<Todo> repository;

  Future<void> initialize(Repository<Todo> repository) async {
    await Future.delayed(Duration(seconds: 3));
    this.repository = repository;
  }
}

final sessionProvider = Provider((_) => SessionService());
