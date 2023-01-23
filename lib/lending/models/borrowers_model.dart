import 'package:flutter/material.dart';

class BorrowersModel extends ChangeNotifier {
  static final _borrowers = [
    const Borrower(name: "Ash Ketchum"),
    const Borrower(name: "Professor Oak"),
    const Borrower(name: "Nurse May"),
  ];

  Iterable<Borrower> get all => _borrowers;
}

class Borrower {
  final String name;

  const Borrower({required this.name});
}
