import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  User? _activeUser;

  static const _users = [
    User(pin: "1234", name: "Alice"),
    User(pin: "4321", name: "Bob"),
  ];

  bool get signedIn => _activeUser != null;

  String get name => _activeUser!.name;

  void signIn({required String pin}) {
    if (_users.any((u) => u.pin == pin)) {
      _activeUser = _users.firstWhere((u) => u.pin == pin);
      notifyListeners();
    }

    throw "Invalid PIN - Use 1234 or 4321";
  }

  void signOut() {
    if (_activeUser == null) {
      throw "Invalid operation. Nobody is signed in.";
    }

    _activeUser = null;
    notifyListeners();
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
