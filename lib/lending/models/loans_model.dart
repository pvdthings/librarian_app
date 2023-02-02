import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';

class LoansModel extends ChangeNotifier {
  static final List<Loan> _loans = [];

  List<Loan> getAll() {
    final loans = _loans;
    loans.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return loans;
  }

  void add(Loan loan) {
    _loans.add(loan);
    notifyListeners();
  }
}

class Loan {
  final String thing;
  final Borrower borrower;
  DateTime dueDate;

  bool get isOverdue {
    final now = DateTime.now();
    return DateUtils.dateOnly(dueDate).isBefore(DateUtils.dateOnly(now));
  }

  bool get isDueToday => DateUtils.isSameDay(DateTime.now(), dueDate);

  Loan({
    required this.thing,
    required this.borrower,
    required this.dueDate,
  });
}
