import 'package:flutter/material.dart';
import 'package:todo_drift_bloc/data/database.dart';
import 'package:todo_drift_bloc/ui/widgets/task_card.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class FailureTaskList extends StatelessWidget {
  final Exception exception;
  const FailureTaskList({Key? key, required this.exception}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(exception.toString()),
    );
  }
}

class TaskList extends StatelessWidget {
  final List<Task> taskList;
  const TaskList({Key? key, required this.taskList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final task = taskList[index];
        return TaskCard(
          task: task,
        );
      },
      itemCount: taskList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 3,
      ),
    );
  }
}

class EmptyTaskList extends StatelessWidget {
  const EmptyTaskList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text('Task list is empty. Press "+" to add Task'));
  }
}

