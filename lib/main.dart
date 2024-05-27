import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test/features/auth/screens/login.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(TaskU());
}
