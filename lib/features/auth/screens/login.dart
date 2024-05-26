import 'package:flutter/material.dart';
import 'package:test/features/begin/screens/tasks_list.dart';
import 'package:test/features/sign_in/screens/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;

class TaskU extends StatelessWidget {
  const TaskU({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ingresar',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: TaskU2(),
    );
  }
}

class TaskU2 extends StatelessWidget {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final fire_auth.FirebaseAuth _auth = fire_auth.FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Log_In'),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(top: 130, bottom: 10, right: 10, left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _controllerEmail,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Usuario o correo electronico',
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
                try {
                  await _auth.signInWithEmailAndPassword(
                      email: _controllerEmail.text,
                      password: _controllerPassword.text);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (builder) =>
                              TasksList(_auth.currentUser!.uid)),
                      (route) => false);
                } catch (e) {
                  final snackBar = SnackBar(
                    content: Text(e.toString()),
                    duration: const Duration(seconds: 5),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: const Text("Ingresar", textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignInUI()),
          );
        },
        child: const Icon(Icons.app_registration_sharp),
      ),
    );
  }
}
