import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LendingApi {
  static Dio get _client => Dio(BaseOptions(
        baseUrl: 'http://localhost:3000/lending', // TODO: update Url
        contentType: 'application/json',
        headers: {
          'supabase-access-token': _accessToken,
          'supabase-refresh-token': _refreshToken,
        },
      ));

  static String get _refreshToken =>
      Supabase.instance.client.auth.currentSession?.refreshToken ?? '';

  static String get _accessToken =>
      Supabase.instance.client.auth.currentSession?.accessToken ?? '';

  static Future<Response> fetchLoans() async {
    return await _client.get('/loans');
  }

  static Future<Response> createLoan(NewLoan data) async {
    return await _client.put('/loans', data: {
      'borrowerId': data.borrowerId,
      'thingIds': data.thingIds,
      'checkedOutDate': data.checkedOutDate,
      'dueBackDate': data.dueBackDate,
      'notes': 'This loan was created by the Librarian app!'
    });
  }

  static Future<Response> updateLoan(UpdatedLoan data) async {
    return await _client.patch('/loans/${data.loanId}/${data.thingId}', data: {
      'checkedInDate': data.checkedInDate,
      'dueBackDate': data.dueBackDate,
    });
  }

  static Future<Response> fetchBorrowers() async {
    return await _client.get('/borrowers');
  }

  static Future<Response> fetchThing({required int number}) async {
    return await _client.get('/things/$number');
  }
}

class NewLoan {
  String borrowerId;
  List<String> thingIds;
  String checkedOutDate;
  String dueBackDate;
  String? notes;

  NewLoan({
    required this.borrowerId,
    required this.thingIds,
    required this.checkedOutDate,
    required this.dueBackDate,
    this.notes,
  });
}

class UpdatedLoan {
  String loanId;
  String thingId;
  String? dueBackDate;
  String? checkedInDate;

  UpdatedLoan({
    required this.loanId,
    required this.thingId,
    this.dueBackDate,
    this.checkedInDate,
  });
}
