import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/authentication/data/user.model.dart';
import 'package:librarian_app/src/features/authentication/services/authentication.service.dart';

class UserViewModel extends ChangeNotifier {
  final service = AuthenticationService();

  bool get signedIn => service.hasValidSession;

  UserModel get user => service.currentUser;

  Future<void> signIn() async {
    await service.signIn();
    notifyListeners();
  }

  Future<void> signOut() async {
    await service.signOut();
    notifyListeners();
  }
}
