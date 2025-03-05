import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_list/domain/data_provider/box_manager.dart';
import 'package:to_do_list/entity/group.dart';
import 'package:to_do_list/ui/navigation/main_navigation.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;
  var _groups = <Group>[];
  List<Group> get groups => _groups.toList();

  GroupsWidgetModel() {
    setup();
  }

  void showForm(BuildContext constext) {
    Navigator.of(constext).pushNamed(MainNavigatonRouteNames.groupsForm);
  }

  Future<void> showTasks(BuildContext context, int groupIndex) async {
    final groupKey = (await _box).keyAt(groupIndex) as int;

    unawaited(Navigator.of(context)
        .pushNamed(MainNavigatonRouteNames.tasks, arguments: groupKey));
  }

  Future<void> deleteGroup(int groupIndex) async {
    final box = await _box;
    await box.deleteAt(groupIndex);
  }

  Future<void> _readGroupsFormHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  void setup() async {
    _box = BoxManager.instance.openGroupBox();
    await BoxManager.instance.openTasksBox();
    _readGroupsFormHive();
    (await _box).listenable().addListener(_readGroupsFormHive);
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;

  const GroupsWidgetModelProvider({
    super.key,
    required this.model,
    required super.child,
  }) : super(
          notifier: model,
        );

  static GroupsWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }

  static GroupsWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupsWidgetModelProvider>()
        ?.widget;
    return widget is GroupsWidgetModelProvider ? widget : null;
  }
}
