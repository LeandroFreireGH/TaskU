import 'package:flutter/material.dart';

class SignInController {
  final TextEditingController controllerSingIn = TextEditingController();

  void dispose() {
    controllerSingIn.dispose();
  }
}
