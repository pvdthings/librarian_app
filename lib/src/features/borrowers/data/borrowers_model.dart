import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/data/lending_api.dart';

import 'borrowers_mapper.dart';

class BorrowersModel extends ChangeNotifier {
  String? _refreshErrorMessage;
  String? get refreshErrorMessage => _refreshErrorMessage;

  set refreshErrorMessage(value) {
    _refreshErrorMessage = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  List<Borrower> _borrowers = [];
  List<Borrower> get borrowers => _borrowers;

  Borrower? _selectedBorrower;
  Borrower? get selectedBorrower => _selectedBorrower;

  set selectedBorrower(value) {
    _selectedBorrower = value;
    notifyListeners();
  }

  Future<void> refresh() async {
    _isLoading = true;
    _borrowers = await getAll();

    if (_selectedBorrower != null) {
      _selectedBorrower =
          _borrowers.firstWhere((b) => b.id == _selectedBorrower!.id);
    }

    _isLoading = false;

    notifyListeners();
  }

  Future<List<Borrower>> getAll() async {
    final response = await LendingApi.fetchBorrowers();
    return BorrowersMapper.map(response.data as List).toList();
  }

  Future<bool> recordCashPayment({
    required String borrowerId,
    required double cash,
  }) async {
    try {
      await LendingApi.recordCashPayment(
        cash: cash,
        borrowerId: borrowerId,
      );
    } catch (error) {
      refreshErrorMessage = error.toString();
      return false;
    }

    refresh();
    return true;
  }
}

class Borrower {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final List<Issue> issues;

  bool get active => issues.isEmpty;

  Borrower({
    required this.id,
    required this.name,
    required this.issues,
    this.email,
    this.phone,
  });
}

class Issue {
  final IssueType type;
  final String title;
  final String? explanation;
  final String? instructions;
  final String? graphicUrl;

  const Issue({
    required this.title,
    this.explanation,
    this.instructions,
    this.graphicUrl,
    required this.type,
  });
}

enum IssueType {
  duesNotPaid,
  overdueLoan,
  suspended,
  needsLiabilityWaiver,
}
