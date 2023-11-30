import 'package:dio/dio.dart';
import 'package:librarian_app/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LendingApi {
  static Dio get _client => Dio(BaseOptions(
        baseUrl: apiHost,
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

  static Future<Response> getCategories() async {
    return await _client.get('/things/categories');
  }

  static Future<Response> fetchLoans() async {
    return await _client.get('/loans');
  }

  static Future<Response> fetchLoan({
    required String id,
    required String thingId,
  }) async {
    return await _client.get('/loans/$id/$thingId');
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

  static Future<Response> updateBorrower(
    String id, {
    String? email,
    String? phone,
  }) async {
    return await _client.patch('/borrowers/$id/contact', data: {
      'email': email,
      'phone': phone,
    });
  }

  static Future<Response> fetchThings() async {
    return await _client.get('/things');
  }

  static Future<Response> fetchThing({required String id}) async {
    return await _client.get('/things/$id');
  }

  static Future<Response> createThing({
    required String name,
    String? spanishName,
  }) async {
    return await _client.put('/things', data: {
      'name': name,
      'spanishName': spanishName,
    });
  }

  static Future<Response> updateThing(
    String thingId, {
    String? name,
    String? spanishName,
    bool? hidden,
    ImageDTO? image,
  }) async {
    return await _client.patch('/things/$thingId', data: {
      'name': name,
      'spanishName': spanishName,
      'hidden': hidden,
      'image': image != null ? {'url': image.url} : null,
    });
  }

  static Future<Response> updateThingCategories(
    String id, {
    required List<String> categories,
  }) async {
    return await _client.patch('/things/$id/categories', data: {
      'categories': categories,
    });
  }

  static Future<Response> deleteThingImage(String thingId) async {
    return await _client.delete('/things/$thingId/image');
  }

  static Future<Response> fetchInventoryItem({required int number}) async {
    return await _client.get('/inventory/$number');
  }

  static Future<Response> createInventoryItems(
    String thingId, {
    required int quantity,
    required String? brand,
    required String? description,
    required double? estimatedValue,
  }) async {
    return await _client.put('/inventory', data: {
      'thingId': thingId,
      'quantity': quantity,
      'brand': brand,
      'description': description,
      'estimatedValue': estimatedValue,
    });
  }

  static Future<Response> updateInventoryItem(
    String id, {
    String? brand,
    String? condition,
    String? description,
    double? estimatedValue,
    bool? hidden,
  }) async {
    return await _client.patch('/inventory/$id', data: {
      'brand': brand,
      'condition': condition,
      'description': description,
      'estimatedValue': estimatedValue,
      'hidden': hidden,
    });
  }

  static Future<Response> fetchPayments({
    required String borrowerId,
  }) async {
    return await _client.get('/payments/$borrowerId');
  }

  static Future<Response> recordCashPayment({
    required double cash,
    required String borrowerId,
  }) async {
    return await _client.put('/payments/$borrowerId', data: {
      'cash': cash,
    });
  }
}

class ImageDTO {
  final String? url;

  const ImageDTO({required this.url});
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
