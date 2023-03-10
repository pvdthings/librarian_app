import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';

import 'things_model.dart';

class LoansModel extends ChangeNotifier {
  static final List<Loan> _loans = [];

  List<Loan> getAll() {
    final loans = _loans.where((l) => l.checkedInDate == null).toList();
    loans.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return loans;
  }

  void open(Loan loan) {
    _loans.add(loan);
    notifyListeners();
  }

  void close(UniqueKey id) {
    _loans.singleWhere((l) => l.id == id).checkedInDate = DateTime.now();
    notifyListeners();
  }

  void updateDueDate(UniqueKey id, DateTime dueDate) {
    _loans.singleWhere((l) => l.id == id).dueDate = dueDate;
    notifyListeners();
  }
}

class Loan {
  final UniqueKey id = UniqueKey();
  final Thing thing;
  final Borrower borrower;
  final DateTime checkedOutDate;
  DateTime dueDate;
  DateTime? checkedInDate;

  bool get isOverdue {
    final now = DateTime.now();
    return DateUtils.dateOnly(dueDate).isBefore(DateUtils.dateOnly(now));
  }

  bool get isDueToday => DateUtils.isSameDay(DateTime.now(), dueDate);

  Loan({
    required this.thing,
    required this.borrower,
    required this.checkedOutDate,
    required this.dueDate,
    this.checkedInDate,
  });
}
