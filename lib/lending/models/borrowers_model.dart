import 'package:flutter/material.dart';
import 'package:librarian_app/lending/api/lending_api.dart';

import 'mappers/borrowers_mapper.dart';

class BorrowersModel extends ChangeNotifier {
  Future<List<Borrower>> getAll() async {
    final response = await LendingApi.fetchBorrowers();
    return BorrowersMapper.map(response.data as List).toList();
  }
}

class Borrower {
  final String name;
  final List<String> issues;

  bool get active => issues.isEmpty;

  Borrower({
    required this.name,
    required this.issues,
  });
}
