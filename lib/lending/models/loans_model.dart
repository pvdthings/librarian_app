import 'package:flutter/material.dart';

class LoansModel extends ChangeNotifier {
  static final List<Loan> _loans = [
    const Loan(
      name: "Alice",
      things: "Chainsaw, Shovel, Rubber Gloves",
      due: "Today",
    ),
    const Loan(
      name: "Bob",
      things: "Coventry-opoly",
      due: "10/31",
    )
  ];

  Iterable<Loan> get activeLoans => _loans;
}

class Loan {
  final String name;
  final String things;
  final String due;

  const Loan({
    required this.name,
    required this.things,
    required this.due,
  });
}
