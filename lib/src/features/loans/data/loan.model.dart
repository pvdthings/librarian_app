import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/data/borrower.model.dart';
import 'package:librarian_app/src/features/loans/data/thing_summary.model.dart';

class LoanModel {
  final String id;
  final ThingSummaryModel thing;
  final BorrowerModel borrower;
  final DateTime checkedOutDate;
  DateTime dueDate;
  DateTime? checkedInDate;

  bool get isOverdue {
    final now = DateTime.now();
    return DateUtils.dateOnly(dueDate).isBefore(DateUtils.dateOnly(now));
  }

  bool get isDueToday => DateUtils.isSameDay(DateTime.now(), dueDate);

  LoanModel({
    required this.id,
    required this.thing,
    required this.borrower,
    required this.checkedOutDate,
    required this.dueDate,
    this.checkedInDate,
  });
}
