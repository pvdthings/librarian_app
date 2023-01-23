import 'package:flutter/material.dart';

class BorrowersModel extends ChangeNotifier {
  static final _borrowers = [
    const Borrower(name: "Alice"),
    const Borrower(name: "Bob"),
    const Borrower(name: "Calum"),
  ];

  Iterable<Borrower> get all => _borrowers;
}

class Borrower {
  final String name;

  const Borrower({required this.name});
}
