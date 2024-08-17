import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/network/local/local.dart';
import 'package:task_management/repository/repository.dart';

import 'package:task_management/route/route.dart' as route;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => ToDoRepository()),
        RepositoryProvider(create: (_) => LocalDBHelper.instance),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: route.AppRoute.splashScreen,
        onGenerateRoute: route.AppRoute.controller,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: const LoginScreen(),
      ),
    );
  }
}
