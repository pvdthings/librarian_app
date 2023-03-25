import 'package:flutter/material.dart';
import 'package:librarian_app/lending/api/lending_api.dart';

class BorrowersModel extends ChangeNotifier {
  static final _borrowers = [
    const Borrower(name: "Ash Ketchum"),
    const Borrower(name: "Professor Oak"),
    const Borrower(name: "Nurse Joy"),
    const Borrower(
      name: "Brock",
      inactiveReasons: [InactiveReasonCode.unpaidDues],
    ),
  ];

  Iterable<Borrower> get all => _borrowers;

  Future<List<Borrower>> getAll() async {
    final response = await LendingApi.fetchBorrowers();
    final data = response.data as List;
    // TODO: map inactive reasons and contact info
    return data
        .map((e) => Borrower(
              name: e['name'] as String,
            ))
        .toList();
  }
}

class Borrower {
  final String name;
  final List<InactiveReasonCode>? inactiveReasons;

  bool get active => inactiveReasons?.isEmpty ?? true;

  const Borrower({
    required this.name,
    this.inactiveReasons,
  });
}

enum InactiveReasonCode { unpaidDues, overdueLoan, banned }
