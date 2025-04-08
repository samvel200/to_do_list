import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_list/domain/data_provider/box_manager.dart';
import 'package:to_do_list/entity/task.dart';
import 'package:to_do_list/ui/navigation/main_navigation.dart';
import 'package:to_do_list/ui/widgets/tasks/tasks_widget.dart';

class TasksWidgetModel extends ChangeNotifier {
  TasksWidgetConfiguration configuration;
  late final Future<Box<Task>> _box;
  ValueListenable<Object>? _listenableBox;
  var _tasks = <Task>[];
  List<Task> get tasks => _tasks.toList();

  TasksWidgetModel({
    required this.configuration,
  }) {
    _setup();
  }

  void showForm(BuildContext constext) {
    Navigator.of(constext).pushNamed(MainNavigatonRouteNames.tasksForm,
        arguments: configuration.groupKey);
  }

  Future<void> deleteTask(int taskIndex) async {
    await (await _box).deleteAt(taskIndex);
  }

  Future<void> doneToggle(int taskIndex) async {
    final task = (await _box).getAt(taskIndex);
    task?.isDone = !task.isDone;
    await task?.save();
  }

  Future<void> _readTasksFormHive() async {
    _tasks = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openTasksBox(configuration.groupKey);

    await _readTasksFormHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readTasksFormHive);
  }

  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readTasksFormHive);
    await BoxManager.instance.closeBox((await _box));
    super.dispose();
  }
}

class TasksWidgetModelProvider extends InheritedNotifier {
  final TasksWidgetModel model;

  const TasksWidgetModelProvider({
    super.key,
    required this.model,
    required super.child,
  }) : super(
          notifier: model,
        );

  static TasksWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksWidgetModelProvider>();
  }

  static TasksWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TasksWidgetModelProvider>()
        ?.widget;
    return widget is TasksWidgetModelProvider ? widget : null;
  }
}
