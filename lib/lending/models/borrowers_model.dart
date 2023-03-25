import 'package:flutter/material.dart';
import 'package:librarian_app/lending/api/lending_api.dart';

class BorrowersModel extends ChangeNotifier {
  Future<List<Borrower>> getAll() async {
    final response = await LendingApi.fetchBorrowers();
    final data = response.data as List;
    // TODO: map contact info
    return data
        .map((e) => Borrower(
              name: e['name'] as String,
              issues: (e['issues'] as List).map((e) => e as String).toList(),
            ))
        .toList();
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

// enum InactiveReasonCode { duesNotPaid, overdueLoan, suspended }
