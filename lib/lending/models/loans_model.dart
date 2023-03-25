import 'package:flutter/material.dart';
import 'package:librarian_app/lending/api/lending_api.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';

import 'mappers/loans_mapper.dart';
import 'things_model.dart';

class LoansModel extends ChangeNotifier {
  static final List<Loan> _loans = [];

  Future<List<Loan>> getAll() async {
    final response = await LendingApi.fetchLoans();
    return LoansMapper.map(response.data as List).toList();
  }

  Future<void> openLoan({
    required String borrowerId,
    required List<String> thingIds,
    required String checkedOutDate,
    required String dueBackDate,
  }) async {
    await LendingApi.createLoan(NewLoan(
      borrowerId: borrowerId,
      thingIds: thingIds,
      checkedOutDate: checkedOutDate,
      dueBackDate: dueBackDate,
    ));
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
