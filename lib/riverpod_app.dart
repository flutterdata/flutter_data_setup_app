import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main.dart';
import 'main.data.dart';
import 'todo.dart';

final initializerProvider = FutureProvider<bool>((ref) async {
  await ref.read(repositoryInitializerProvider().future);
  final repository = ref.read(todosRepositoryProvider);
  await ref.read(sessionProvider).initialize(repository);
  return true;
});

class RiverpodTodoApp extends StatelessWidget {
  @override
  Widget build(context) {
    return ProviderScope(
      overrides: [
        configureRepositoryLocalStorage(),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: Consumer(
              builder: (context, read, child) {
                // could simply use:
                // read(repositoryInitializerProvider()).when()
                return read(initializerProvider).when(
                  data: (_) {
                    // Flutter Data repositories are ready at this point!
                    final repository = read(todosRepositoryProvider);
                    return GestureDetector(
                      onDoubleTap: () async {
                        print((await repository.findOne(1, remote: false))
                            ?.title);
                        final todo = await Todo(id: 1, title: 'blah')
                            .init(context.read)
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
              },
            ),
          ),
        ),
      ),
    );
  }
}
