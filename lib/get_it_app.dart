import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:get_it/get_it.dart';

import 'main.data.dart';
import 'todo.dart';

class GetItTodoApp extends StatelessWidget {
  @override
  Widget build(context) {
    GetIt.instance.registerRepositories();
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
                      .init()
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

extension GetItFlutterDataX on GetIt {
  void registerRepositories(
      {FutureFn<String> baseDirFn,
      List<int> encryptionKey,
      bool clear,
      bool remote,
      bool verbose}) {
    final i = GetIt.instance;

    final _container = ProviderContainer(
      overrides: [
        configureRepositoryLocalStorage(
            baseDirFn: baseDirFn, encryptionKey: encryptionKey, clear: clear),
      ],
    );

    if (i.isRegistered<RepositoryInitializer>()) {
      return;
    }

    i.registerSingletonAsync<RepositoryInitializer>(() async {
      final init = _container.read(
          repositoryInitializerProvider(remote: remote, verbose: verbose)
              .future);
      internalLocatorFn =
          <T extends DataModel<T>>(RootProvider<Object, Repository<T>> provider,
                  _) =>
              _container.read(provider);
      return init;
    });
    i.registerSingletonWithDependencies<Repository<Todo>>(
        () => _container.read(todoRepositoryProvider),
        dependsOn: [RepositoryInitializer]);
  }
}
