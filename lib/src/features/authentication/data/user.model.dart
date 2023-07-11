import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  final String name;

  const UserModel({required this.name});

  factory UserModel.from(User? supabaseUser) {
    final name = supabaseUser?.userMetadata?['full_name'] ??
        supabaseUser?.email ??
        'Alice';

    return UserModel(name: name);
  }
}
