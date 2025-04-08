import 'package:flutter/material.dart';
import 'package:to_do_list/domain/data_provider/box_manager.dart';
import 'package:to_do_list/entity/task.dart';

class TaskFormWidgetModel {
  int groupKey;
  var tasksText = '';

  TaskFormWidgetModel({
    required this.groupKey,
  });

  Future<void> saveTask(BuildContext context) async {
    if (tasksText.isEmpty) return;

    final task = Task(text: tasksText, isDone: false);
    final box = await BoxManager.instance.openTasksBox(groupKey);
    await box.add(task);
    //  await BoxManager.instance.closeBox(box);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
}

class TaskFormWidgetModelProvider extends InheritedWidget {
  final TaskFormWidgetModel model;
  const TaskFormWidgetModelProvider({
    super.key,
    required this.model,
    required super.child,
  });

  static TaskFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskFormWidgetModelProvider>();
  }

  static TaskFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TaskFormWidgetModelProvider>()
        ?.widget;
    return widget is TaskFormWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(TaskFormWidgetModelProvider oldWidget) {
    return false;
  }
}
