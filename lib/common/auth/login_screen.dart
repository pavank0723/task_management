import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_management/res/res.dart';
import 'package:task_management/route/route.dart';
import 'package:task_management/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _authService.signInWithEmail(email, password);
    if (user != null) {
      // Navigate to Home Screen
      debugPrint('User Data ====> ${user.email}');
      Navigator.pushReplacementNamed(context, AppRoute.toDoScreen);
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to log in')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppString.stringLogin)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: AppString.lblEmail),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: AppString.lblPassword),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text(AppString.stringLogin),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoute.registerScreen);
              },
              child: const Text(AppString.stringNotAccount),
            ),
          ],
        ),
      ),
    );
  }
}
