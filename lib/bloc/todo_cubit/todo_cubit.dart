import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_drift_bloc/bloc/todo_cubit/todo_state.dart';
import 'package:todo_drift_bloc/data/database.dart';

class TaskCubit extends Cubit<TaskState> {
  final AppDatabase _db = AppDatabase();

  TaskCubit() : super(TaskLoadingState());

  // Получаем все Task'и
  getTasks() async {
    if (state is TaskLoadSucceedState == false) {
      emit(TaskLoadingState());
    }

    try {
      final taskList = await _db.getAllTasks();
      emit(TaskLoadSucceedState(taskList: taskList));
    } catch (e) {
      emit(TaskLoadFailureState(exception: (e as Exception)));
    }
  }

  // Создаем Task
  createTask(TasksCompanion tasksCompanion) async {
    await _db.insertTask(tasksCompanion);
    getTasks();
  }
  // Удаляем Task
  deleteTask(Task task) async {
    await _db.deleteTask(task);
    getTasks();
  }
  // Обновляем Task
  updateTask(Task task) async {
    await _db.updateTask(task);
    getTasks();
  }
  // Обновляем чекбокс через isComplete в db
  updateTaskIsComplete(Task task, bool isComplete) async {
    await _db.updateTaskIsCompele(task, isComplete);
    getTasks();
  }
}

