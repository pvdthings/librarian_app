import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LendingApi {
  static Dio get _client =>
      Dio(BaseOptions(contentType: 'application/json', headers: {
        'supabase-access-token': _accessToken,
        'supabase-refresh-token': _refreshToken,
      }));

  static String get _refreshToken =>
      Supabase.instance.client.auth.currentSession?.refreshToken ?? '';

  static String get _accessToken =>
      Supabase.instance.client.auth.currentSession?.accessToken ?? '';

  static Future<Response> fetchLoans() async {
    return await _client.get('http://localhost:3000/lending/loans');
  }
}
