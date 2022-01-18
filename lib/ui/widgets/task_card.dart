import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_drift_bloc/bloc/todo_cubit/todo_cubit.dart';
import 'package:todo_drift_bloc/data/database.dart';
import 'package:todo_drift_bloc/ui/screens/task_detail_page.dart';
import 'package:drift/drift.dart' as drift;

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailTaskPage(
                title: 'Edit Task',
                tasksCompanion: TasksCompanion(
                    id: drift.Value(task.id),
                    title: drift.Value(task.title),
                    description: drift.Value(task.description),
                    dueDate: drift.Value(task.dueDate),
                    isCompeteld: drift.Value(task.isCompeteld)),
              ),
            ));
      },
      child: Card(
        color: task.isCompeteld ? Colors.grey[400] : Colors.white,
        child: Slidable(
          key: UniqueKey(),
          endActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(onDismissed: () {
              BlocProvider.of<TaskCubit>(context, listen: false)
                  .deleteTask(task);
            }),
            children: [
              SlidableAction(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                  onPressed: (context) => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete this Task?'),
                          content:
                              Text('Do you want to delete Task ${task.title}'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                BlocProvider.of<TaskCubit>(context,
                                        listen: false)
                                    .deleteTask(task);
                                Navigator.pop(context);
                              },
                              child: const Text('Ok'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        );
                      })),
            ],
          ),
          closeOnScroll: true,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(
                      task.title,
                      style: const TextStyle(fontSize: 24),
                      maxLines: 2,
                    )),
                    Checkbox(
                        value: task.isCompeteld,
                        onChanged: (newValue) {
                          BlocProvider.of<TaskCubit>(context)
                              .updateTaskIsComplete(task, newValue!);
                        }),
                  ],
                ),
                Text(
                  task.description,
                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                  maxLines: 8,
                ),
                task.dueDate == null
                    ? Container()
                    : Row(
                        children: [
                          const Expanded(child: SizedBox()),
                          Text(DateFormat.yMMMd().format(task.dueDate!)),
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
