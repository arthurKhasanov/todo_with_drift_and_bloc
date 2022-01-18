import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_drift_bloc/bloc/date_time_cubit/date_time_cubit.dart';
import 'package:todo_drift_bloc/bloc/date_time_cubit/date_time_state.dart';
import 'package:todo_drift_bloc/bloc/todo_cubit/todo_cubit.dart';
import 'package:todo_drift_bloc/data/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';

class DetailTaskPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final String title;
  final TasksCompanion tasksCompanion;
  final _titleEditingController = TextEditingController();
  final _descriptionEditingController = TextEditingController();
  DateTime? _dueDate;

  DetailTaskPage({Key? key, required this.title, required this.tasksCompanion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _titleEditingController.text = tasksCompanion.title.value;
    _descriptionEditingController.text = tasksCompanion.description.value;
    _dueDate = tasksCompanion.dueDate.value;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              submitForm(context);
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) => _validateTitle(value),
                      controller: _titleEditingController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Task title',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: (value) => _validateDescription(value),
                    controller: _descriptionEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Task description',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    maxLength: 255,
                    minLines: 3,
                    maxLines: 8,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Add due date'),
                Row(
                  children: [
                    BlocBuilder<DateTimeCubit, DateTimeState>(
                        builder: (context, state) {
                      if (state is DateTimeIsNotSet || _dueDate == null) {
                        return Container();
                      } else {
                        return Text(DateFormat.yMMMd().format(_dueDate!));
                      }
                    }),
                    IconButton(
                        onPressed: () async {
                          _dueDate = await showDatePicker(
                              context: context,
                              initialDate:
                                  _dueDate == null ? DateTime.now() : _dueDate!,
                              firstDate: DateTime(2010),
                              lastDate: DateTime(2050));
                          if (_dueDate != null) {
                            BlocProvider.of<DateTimeCubit>(context)
                                .dateTimeIsSet(_dueDate!);
                          }
                        },
                        icon: const Icon(Icons.calendar_today))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _createOrUpdateTask(context);
      Navigator.pop(context);
    }

    
  }
  // Если Task имеет id то изменения сохранятся и заменять старый Task с этим id в db   
  void _createOrUpdateTask(BuildContext context) {
    if (tasksCompanion.id.present) {
      BlocProvider.of<TaskCubit>(context, listen: false).updateTask(Task(
          id: tasksCompanion.id.value,
          title: _titleEditingController.text,
          description: _descriptionEditingController.text,
          dueDate: _dueDate,
          isCompeteld: tasksCompanion.isCompeteld.value));
    } else {
      BlocProvider.of<TaskCubit>(context, listen: false)
          .createTask(TasksCompanion(
        title: drift.Value(_titleEditingController.text),
        description: drift.Value(_descriptionEditingController.text),
        dueDate: drift.Value(_dueDate),
      ));
    }
  }
}

//NOTE: validator

String? _validateTitle(String? value) {
  if (value == null || value.isEmpty) {
    return 'Title length must be more then 1 symbol';
  } else {
    return null;
  }
}
String? _validateDescription(String? value) {
  if (value == null || value.length < 6) {
    return 'Title length must be more then 6 symbol';
  } else {
    return null;
  }
}


