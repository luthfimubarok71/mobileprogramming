// login_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'otp_page.dart';

enum ButtonState { init, loading, done }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  ButtonState state = ButtonState.init;

  Future<void> _handleLogin() async {
    setState(() => state = ButtonState.loading);
    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    final savedPassword = prefs.getString('password');

    final inputUsername = usernameController.text;
    final inputPassword = passwordController.text;

    if (inputUsername == savedUsername && inputPassword == savedPassword) {
      setState(() => state = ButtonState.done);
      await Future.delayed(const Duration(seconds: 1));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OtpPage()),
      );
    } else {
      setState(() => state = ButtonState.init);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login gagal, username/password salah')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 8,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: buildButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton() {
    final isStretched = state == ButtonState.init;
    final isDone = state == ButtonState.done;

    return SizedBox(
      height: 50,
      width: isStretched ? double.infinity : 50,
      child: isStretched
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(
                  side: BorderSide(width: 2, color: Colors.indigo),
                ),
              ),
              onPressed: _handleLogin,
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.indigo,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : buildSmallButton(isDone),
    );
  }

  Widget buildSmallButton(bool isDone) {
    final color = isDone ? Colors.green : Colors.indigo;

    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Center(
        child: isDone
            ? const Icon(Icons.done, size: 32, color: Colors.white)
            : const Padding(
                padding: EdgeInsets.all(12.0),
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              ),
      ),
    );
  }
}