import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel extends ChangeNotifier {
  static SupabaseClient get supabase => Supabase.instance.client;

  bool get signedIn => supabase.auth.currentSession != null;

  String get name => supabase.auth.currentUser!.id;

  void signIn() {
    supabase.auth
        .signInWithOAuth(Provider.discord)
        .whenComplete(() => notifyListeners());
  }

  void signOut() {
    supabase.auth.signOut().whenComplete(() => notifyListeners());
  }
}
