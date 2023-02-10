import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String? _pin;

  static const _users = [
    User(pin: "1234", name: "Alice"),
    User(pin: "4321", name: "Bob"),
  ];

  bool get signedIn => _pin != null;

  void signIn({required String pin}) {
    if (_users.any((u) => u.pin == pin)) {
      _pin = pin;
      notifyListeners();
    }

    throw "Invalid PIN";
  }
}

class User {
  final String pin;
  final String name;

  const User({
    required this.pin,
    required this.name,
  });
}
