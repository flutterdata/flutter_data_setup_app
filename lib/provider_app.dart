import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider, FutureProvider;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'main.dart';
import 'main.data.dart';
import 'todo.dart';

class ProviderTodoApp extends StatelessWidget {
  @override
  Widget build(context) {
    return MultiProvider(
      providers: [
        ...providers(clear: true),
        ProxyProvider<Repository<Todo>, SessionService>(
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
                        .init(context.read<ProviderContainer>().read)
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

List<SingleChildWidget> providers(
    {FutureFn<String> baseDirFn,
    List<int> encryptionKey,
    bool clear,
    bool remote,
    bool verbose}) {
  return [
    Provider(
      create: (_) => ProviderContainer(overrides: [
        configureRepositoryLocalStorage(
            baseDirFn: baseDirFn, encryptionKey: encryptionKey, clear: clear),
      ]),
    ),
    FutureProvider<RepositoryInitializer>(
      create: (context) async {
        return await Provider.of<ProviderContainer>(context, listen: false)
            .read(
                repositoryInitializerProvider(remote: remote, verbose: verbose)
                    .future);
      },
    ),
    ProxyProvider<RepositoryInitializer, Repository<Todo>>(
      lazy: false,
      update: (context, i, __) => i == null
          ? null
          : Provider.of<ProviderContainer>(context, listen: false)
              .read(todoRepositoryProvider),
      dispose: (_, r) => r?.dispose(),
    ),
  ];
}
