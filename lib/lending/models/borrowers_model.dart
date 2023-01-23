import 'package:flutter/material.dart';

class BorrowersModel extends ChangeNotifier {
  static final _borrowers = [
    const Borrower(name: "Ash Ketchum"),
    const Borrower(name: "Professor Oak"),
    const Borrower(name: "Nurse May"),
    const Borrower(
      name: "Brock",
      inactiveReasons: [InactiveReasonCode.overdueLoan],
    ),
  ];

  Iterable<Borrower> get all => _borrowers;
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
