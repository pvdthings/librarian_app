import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';

class LoansModel extends ChangeNotifier {
  List<Loan> getAll() {
    final today = DateUtils.dateOnly(DateTime.now());

    return [
      Loan(
        thing: "Pokédex",
        borrower: const Borrower(name: "Ash Ketchum"),
        dueDate: today,
      ),
      Loan(
        thing: "Flyswatter",
        borrower: const Borrower(name: "Ash Ketchum"),
        dueDate: today,
      ),
      Loan(
        thing: "Kanto Map",
        borrower: const Borrower(name: "Brock"),
        dueDate: today.subtract(const Duration(days: 14)),
      ),
      Loan(
        thing: "Pokémon Incubator",
        borrower: const Borrower(name: "Professor Oak"),
        dueDate: today.add(const Duration(days: 3)),
      ),
    ];
  }
}

class Loan {
  final String thing;
  final Borrower borrower;
  final DateTime dueDate;

  bool get isOverdue {
    final now = DateTime.now();
    return DateUtils.dateOnly(dueDate).isBefore(DateUtils.dateOnly(now));
  }

  bool get isDueToday => DateUtils.isSameDay(DateTime.now(), dueDate);

  const Loan({
    required this.thing,
    required this.borrower,
    required this.dueDate,
  });
}
