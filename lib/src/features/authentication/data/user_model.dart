import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel extends ChangeNotifier {
  static SupabaseClient get _supabase => Supabase.instance.client;
  static User? get _currentUser => _supabase.auth.currentUser;

  bool get signedIn => _supabase.auth.currentSession != null;

  String get name =>
      _currentUser?.userMetadata?['full_name'] ??
      _currentUser?.email ??
      'Alice';

  void signIn() {
    _supabase.auth
        .signInWithOAuth(Provider.discord)
        .whenComplete(() => notifyListeners());
  }

  void signOut() {
    _supabase.auth.signOut().whenComplete(() => notifyListeners());
  }
}
