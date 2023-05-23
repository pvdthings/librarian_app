import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/data/lending_api.dart';

import 'borrowers_mapper.dart';

class BorrowersModel extends ChangeNotifier {
  Future<List<Borrower>> getAll() async {
    final response = await LendingApi.fetchBorrowers();
    return BorrowersMapper.map(response.data as List).toList();
  }
}

class Borrower {
  final String id;
  final String name;
  final List<String> issues;

  bool get active => issues.isEmpty;

  Borrower({
    required this.id,
    required this.name,
    required this.issues,
  });
}