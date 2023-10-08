import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  final String name;
  final String? pictureUrl;

  const UserModel({
    required this.name,
    this.pictureUrl,
  });

  factory UserModel.from(User? supabaseUser) {
    final metadata = supabaseUser?.userMetadata;
    final name = metadata?['full_name'] ?? supabaseUser?.email ?? 'Alice';

    return UserModel(
      name: name,
      pictureUrl: metadata?['picture'],
    );
  }
}
