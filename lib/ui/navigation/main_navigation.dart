import 'package:flutter/material.dart';

import 'package:to_do_list/group_form/group_form_widget.dart';
import 'package:to_do_list/ui/widgets/groups/groups_widget.dart';
import 'package:to_do_list/ui/widgets/task_form/task_form_widget.dart';
import 'package:to_do_list/ui/widgets/tasks/tasks_widget.dart';

abstract class MainNavigatonRouteNames {
  static const groups = '/';
  static const groupsForm = '/groupsForm';
  static const tasks = '/tasks';
  static const tasksForm = '/tasks/form';
}

class MainNavigation {
  final initialRoute = MainNavigatonRouteNames.groups;
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigatonRouteNames.groups: (context) => const GroupsWidget(),
    MainNavigatonRouteNames.groupsForm: (context) => const GroupFormWidget(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigatonRouteNames.tasks:
        final configuration = settings.arguments as TasksWidgetConfiguration;
        return MaterialPageRoute(
            builder: (context) => TasksWidget(
                  configuration: configuration,
                ));
      case MainNavigatonRouteNames.tasksForm:
        final groupKey = settings.arguments as int;
        return MaterialPageRoute(
            builder: (context) => TaskFormWidget(groupKey: groupKey));
      default:
        const widget = Text('Navigation Error !!!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}
