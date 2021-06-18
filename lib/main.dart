import 'package:flutter/material.dart';
import 'package:flutter_data_setup_app/get_it_app.dart';
import 'package:flutter_data_setup_app/provider_app.dart';
import 'package:flutter_data_setup_app/riverpod_app.dart';
import 'package:flutter_data_setup_app/todo.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore_for_file: unused_import

void main() {
  runApp(RiverpodTodoApp());
  // runApp(ProviderTodoApp());
  // runApp(GetItTodoApp());
}

class SessionService {
  late final Repository<Todo> repository;

  Future<void> initialize(Repository<Todo> repository) async {
    await Future.delayed(Duration(seconds: 3));
    this.repository = repository;
  }
}

final sessionProvider = Provider((_) => SessionService());
