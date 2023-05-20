import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:librarian_app/api/lending_api.dart';
import 'package:librarian_app/models/borrowers_model.dart';

import 'mappers/loans_mapper.dart';
import 'things_model.dart';

class LoansModel extends ChangeNotifier {
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

  Future<void> closeLoan({
    required String loanId,
    required String thingId,
  }) async {
    final dateFormat = DateFormat('yyyy-MM-dd');

    await LendingApi.updateLoan(UpdatedLoan(
      loanId: loanId,
      thingId: thingId,
      checkedInDate: dateFormat.format(DateTime.now()),
    ));
  }

  Future<void> updateDueDate({
    required String loanId,
    required String thingId,
    required DateTime dueBackDate,
  }) async {
    final dateFormat = DateFormat('yyyy-MM-dd');

    await LendingApi.updateLoan(UpdatedLoan(
      loanId: loanId,
      thingId: thingId,
      dueBackDate: dateFormat.format(dueBackDate),
    ));
  }
}

class Loan {
  final String id;
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
    required this.id,
    required this.thing,
    required this.borrower,
    required this.checkedOutDate,
    required this.dueDate,
    this.checkedInDate,
  });
}
