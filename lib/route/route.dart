import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/common/common.dart';
import 'package:task_management/model/model.dart';
import 'package:task_management/network/local/local.dart';
import 'package:task_management/repository/repository.dart';
import 'package:task_management/ui/screens/screens.dart';
import 'package:task_management/ui/screens/to_do_screen/all_to_do/to_do_screen_bloc.dart';
import 'package:task_management/ui/screens/to_do_screen/to_do_detail_screen/to_do_detail_screen.dart';
import 'package:task_management/ui/screens/to_do_screen/to_do_detail_screen/to_do_detail_screen_bloc.dart';

class AppRoute {
  static const String splashScreen = '/';
  static const String loginScreen = '/loginScreen';
  static const String registerScreen = '/registerScreen';
  static const String toDoScreen = '/toDoScreen';
  static const String addToDoScreen = '/addToDoScreen';
  static const String unKnownScreen = '/unKnownScreen';

  static Route<dynamic> controller(RouteSettings settings) {
    final args = settings.arguments;
    T instanceOf<T>(BuildContext context) {
      return RepositoryProvider.of<T>(context);
    }

    switch (settings.name) {
      case AppRoute.splashScreen:
        return MaterialPageRoute(
            builder: (context) => const SplashScreen(), settings: settings);
      case AppRoute.loginScreen:
        return MaterialPageRoute(
            builder: (context) => const LoginScreen(), settings: settings);
      case AppRoute.registerScreen:
        return MaterialPageRoute(
            builder: (context) => const RegisterScreen(), settings: settings);
      case AppRoute.toDoScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => ToDoScreenBloc(
                    instanceOf<ToDoRepository>(context),
                    instanceOf<LocalDBHelper>(context),
                  ),
                  child: const ToDoScreen(),
                ),
            settings: settings);
      case AppRoute.addToDoScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => ToDoDetailScreenBloc(
                    instanceOf<ToDoRepository>(context),
                    instanceOf<LocalDBHelper>(context),
                  ),
                  child: ToDoDetailScreen(
                    task: args as ToDoModel?,
                  ),
                ),
            settings: settings);

      default:
        return MaterialPageRoute(
            builder: (context) => const UnknownScreen(), settings: settings);
    }
  }
}
