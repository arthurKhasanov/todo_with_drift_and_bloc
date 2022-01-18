import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 50)();
  TextColumn get description => text().withLength(min: 6, max: 255)();
  DateTimeColumn get dueDate => dateTime().nullable()();
  BoolColumn get isCompeteld => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // получение Task'ов из дб
  Future<List<Task>> getAllTasks() => select(tasks).get();

  // Добавление Task в дб
  Future insertTask(TasksCompanion tasksCompanion) =>
      into(tasks).insert(tasksCompanion);

  // Удаление Task из дб
  Future deleteTask(Task task) => delete(tasks).delete(task);

  // Обновить Task в дб

  Future updateTask(Task task) => update(tasks).replace(task);

  // Обновить свойство isComplete
  Future updateTaskIsCompele(Task task, bool isComplete) {
    final Task updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      isCompeteld: isComplete,
    );
    return update(tasks).replace(updatedTask);
  }
}

LazyDatabase _openConnection() {
  // LazyDatabase позволяет найти правильное нахождение для файла
  return LazyDatabase(() async {
    // Вставляет дб файл с названием "db.sqlite" в папке документы
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
