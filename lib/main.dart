import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_drift_bloc/bloc/todo_cubit/todo_cubit.dart';
import 'package:todo_drift_bloc/ui/screens/task_list_page.dart';

import 'bloc/date_time_cubit/date_time_cubit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Подключаем Кубиты в начало дерева
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskCubit>(
          create: (context) => TaskCubit()..getTasks(),
        ),
        BlocProvider(create: (context) => DateTimeCubit())
      ],
      child: const MaterialApp(
        title: 'Material App',
        home: TaskListPage(),
      ),
    );
  }
}
