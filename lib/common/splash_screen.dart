import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_management/route/route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () async {
      Navigator.pushReplacementNamed(
        context,
        _getInitialRoute(),
      );
    });
  }

  String _getInitialRoute() {
    final user = FirebaseAuth.instance.currentUser;
    return user == null ? AppRoute.loginScreen : AppRoute.toDoScreen;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: size.height / 2 - 100,
          child: Column(
            children: [
              Text(
                'Task Management',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Loading...'),
            ],
          ),
        ),
      ),
    );
  }
}
