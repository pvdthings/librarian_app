import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/data/lending_api.dart';

import 'borrowers_mapper.dart';

class BorrowersModel extends ChangeNotifier {
  Borrower? _selectedBorrower;

  Borrower? get selectedBorrower => _selectedBorrower;

  set selectedBorrower(value) {
    _selectedBorrower = value;
    notifyListeners();
  }

  Future<List<Borrower>> getAll() async {
    final response = await LendingApi.fetchBorrowers();
    return BorrowersMapper.map(response.data as List).toList();
  }
}

class Borrower {
  final String id;
  final String name;
  final List<Issue> issues;

  bool get active => issues.isEmpty;

  Borrower({
    required this.id,
    required this.name,
    required this.issues,
  });
}

class Issue {
  final String title;
  final String? explanation;
  final String? instructions;
  final String? graphicUrl;

  const Issue({
    required this.title,
    this.explanation,
    this.instructions,
    this.graphicUrl,
  });
}
