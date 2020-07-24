// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: directives_ordering, top_level_function_literal_block

import 'package:flutter_data/flutter_data.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart' as p;
import 'package:provider/single_child_widget.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_data_setup_app/todo.dart';

Override configureRepositoryLocalStorage(
    {FutureFn<String> baseDirFn, List<int> encryptionKey, bool clear}) {
  // ignore: unnecessary_statements
  baseDirFn ??=
      () => getApplicationDocumentsDirectory().then((dir) => dir.path);
  return hiveLocalStorageProvider.overrideAs(Provider((_) => HiveLocalStorage(
      baseDirFn: baseDirFn, encryptionKey: encryptionKey, clear: clear)));
}

FutureProvider<RepositoryInitializer> repositoryInitializerProvider(
    {bool remote, bool verbose, FutureFn alsoAwait}) {
  internalLocatorFn = (provider, context) => provider.read(context);

  return _repositoryInitializerProviderFamily(
      RepositoryInitializerArgs(remote, verbose, alsoAwait));
}

final _repositoryInitializerProviderFamily =
    FutureProvider.family<RepositoryInitializer, RepositoryInitializerArgs>(
        (ref, args) async {
  final graphs = <String, Map<String, RemoteAdapter>>{
    'todos': {'todos': ref.read(todoRemoteAdapterProvider)}
  };
  await ref.read(todoRepositoryProvider).initialize(
        remote: args?.remote,
        verbose: args?.verbose,
        adapters: graphs['todos'],
        ref: ref,
      );
  if (args?.alsoAwait != null) {
    await args.alsoAwait();
  }
  return RepositoryInitializer();
});

List<SingleChildWidget> repositoryProviders(
    {FutureFn<String> baseDirFn,
    List<int> encryptionKey,
    bool clear,
    bool remote,
    bool verbose,
    FutureFn alsoAwait}) {
  return [
    p.Provider(
      create: (_) => ProviderStateOwner(overrides: [
        configureRepositoryLocalStorage(
            baseDirFn: baseDirFn, encryptionKey: encryptionKey, clear: clear),
      ]),
    ),
    p.FutureProvider<RepositoryInitializer>(
      create: (context) async {
        final init =
            await p.Provider.of<ProviderStateOwner>(context, listen: false)
                .ref
                .read(repositoryInitializerProvider(
                    remote: remote, verbose: verbose, alsoAwait: alsoAwait));
        internalLocatorFn = (provider, context) => provider.readOwner(
            p.Provider.of<ProviderStateOwner>(context, listen: false));
        return init;
      },
    ),
    p.ProxyProvider<RepositoryInitializer, Repository<Todo>>(
      lazy: false,
      update: (context, i, __) => i == null
          ? null
          : p.Provider.of<ProviderStateOwner>(context, listen: false)
              .ref
              .read(todoRepositoryProvider),
      dispose: (_, r) => r?.dispose(),
    ),
  ];
}

extension GetItFlutterDataX on GetIt {
  void registerRepositories(
      {FutureFn<String> baseDirFn,
      List<int> encryptionKey,
      bool clear,
      bool remote,
      bool verbose}) {
    final i = GetIt.instance;

    final _owner = ProviderStateOwner(
      overrides: [
        configureRepositoryLocalStorage(
            baseDirFn: baseDirFn, encryptionKey: encryptionKey, clear: clear),
      ],
    );

    if (i.isRegistered<RepositoryInitializer>()) {
      return;
    }

    i.registerSingletonAsync<RepositoryInitializer>(() async {
      final init = _owner.ref.read(
          repositoryInitializerProvider(remote: remote, verbose: verbose));
      internalLocatorFn = (provider, _) => provider.readOwner(_owner);
      return init;
    });
    i.registerSingletonWithDependencies<Repository<Todo>>(
        () => _owner.ref.read(todoRepositoryProvider),
        dependsOn: [RepositoryInitializer]);
  }
}
