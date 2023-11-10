import 'package:flutter/material.dart';

import '../datamanager/User.dart';
import '../login/authservice.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = (await _authService.signInWithEmailAndPassword(email, password)) as User?;
    if (user != null) {
      if (user.uid == "Test") {
        /*// If the user is a SuperAdmin, navigate to the SuperAdmin interface
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SuperAdminInterface()),
        );
      } else {
        // If the user is a Chef of an Innovation Hub, navigate to the Chef interface
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChefInterface()),
        );*/
      }
    } else {
      // Handle the error
      print("Login failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: _login,
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}