import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';

class LoansModel extends ChangeNotifier {
  List<Loan> getAll() {
    return [
      const Loan(
        borrower: Borrower(name: "Ash Ketchum"),
        things: "Pokédex, Flyswatter",
        due: "Today",
      ),
      const Loan(
        borrower: Borrower(name: "Brock"),
        things: "UltraBall, Kanto Map",
        due: "1/5",
        isOverdue: true,
      ),
    ];
  }
}

class Loan {
  final String things;
  final String due;
  final Borrower borrower;
  final bool isOverdue;

  const Loan({
    required this.borrower,
    required this.things,
    required this.due,
    this.isOverdue = false,
  });
}
