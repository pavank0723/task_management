import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_management/common/auth/auth.dart';
import 'package:task_management/res/app_string.dart';
import 'package:task_management/route/route.dart';
import 'package:task_management/utils/utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _signUp() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _authService.signUpWithEmail(email, password);
    if (user != null) {
      Navigator.pushReplacementNamed(context, AppRoute.toDoScreen);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to register')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppString.stringRegister)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: AppString.lblEmail),
            ),
            TextField(
              controller: _passwordController,
              decoration:
                  const InputDecoration(labelText: AppString.lblPassword),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUp,
              child: const Text(AppString.stringRegister),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text(AppString.stringAlreadyAccount),
            ),
          ],
        ),
      ),
    );
  }
}
