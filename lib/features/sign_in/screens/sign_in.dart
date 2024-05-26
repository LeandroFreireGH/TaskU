import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:test/features/auth/screens/login.dart';

class SignInUI extends StatefulWidget {
  @override
  _SignInUI createState() => _SignInUI();
}

class _SignInUI extends State<SignInUI> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final fire_auth.FirebaseAuth _auth = fire_auth.FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Sign_In'),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(top: 130, bottom: 10, right: 10, left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            TextField(
              controller: _controllerEmail,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Correo electrónico',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controllerPassword,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contraseña',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () async {
                String email = _controllerEmail.text;
                String password = _controllerPassword.text;
                try {
                  await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => const TaskU()),
                      (route) => false);
                } catch (e) {
                  final snackBar = SnackBar(
                    content: Text(e.toString()),
                    duration: const Duration(seconds: 5),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Text("Registrarse", textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}

// libreria
// import 'package:firebase_auth/firebase_auth.dart' as fire_auth;

// esto va dentro de la clase state
// final fire_auth.FirebaseAuth _auth = fire_auth.FirebaseAuth.instance;

// esto va cuando presionas el boton
/*try {
  await _auth.createUserWithEmailAndPassword(
     email: _emailController.text,
      password: _passwordController.text);
  setState(() {
    circular = false;
  });
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (builder) => const LoginScreen()),
      (route) => false);
} catch (e) {
  final snackBar = SnackBar(
    content: Text(e.toString()),
    duration: const Duration(seconds: 5),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  setState(() {
    circular = false;
  });
}*/