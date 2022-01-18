import 'package:todo_drift_bloc/data/database.dart';

abstract class TaskState {}

class TaskLoadingState extends TaskState {}

class TaskLoadSucceedState extends TaskState {
  List<Task> taskList;
  TaskLoadSucceedState({required this.taskList});
}

class TaskLoadFailureState extends TaskState {
  Exception exception;
  TaskLoadFailureState({required this.exception});
}


