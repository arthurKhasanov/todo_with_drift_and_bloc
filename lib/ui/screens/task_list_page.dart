import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_drift_bloc/bloc/todo_cubit/todo_cubit.dart';
import 'package:todo_drift_bloc/bloc/todo_cubit/todo_state.dart';
import 'package:todo_drift_bloc/data/database.dart';
import 'package:todo_drift_bloc/ui/screens/task_detail_page.dart';
import 'package:todo_drift_bloc/ui/widgets/state_views.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo with Drift/BLoC'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailTaskPage(
                  title: 'Add Task',
                  tasksCompanion: const TasksCompanion(
                    title: drift.Value(''),
                    description: drift.Value(''),
                  ),
                ),
              ));
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoadSucceedState) {
            return state.taskList.isEmpty
                ? const EmptyTaskList()
                : TaskList(taskList: state.taskList);
          } else if (state is TaskLoadFailureState) {
            return FailureTaskList(
              exception: state.exception,
            );
          } else {
            return const LoadingView();
          }
        },
      ),
    );
  }
}

