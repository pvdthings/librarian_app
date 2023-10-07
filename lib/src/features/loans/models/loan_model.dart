import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/models/borrower_model.dart';
import 'package:librarian_app/src/features/loans/models/thing_summary_model.dart';

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

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'] as String? ?? '?',
      thing: ThingSummaryModel.fromJson(json['thing'] as Map<String, dynamic>),
      borrower: BorrowerModel(
        id: json['borrower']?['id'] as String? ?? '?',
        name: json['borrower']?['name'] as String? ?? '???',
        issues: [],
      ),
      checkedOutDate: json['checkedOutDate'] != null
          ? DateTime.parse(json['checkedOutDate'] as String)
          : DateTime.now(),
      checkedInDate: json['checkedInDate'] != null
          ? DateTime.parse(json['checkedInDate'] as String)
          : null,
      dueDate: json['dueBackDate'] != null
          ? DateTime.parse(json['dueBackDate'])
          : DateTime.now(),
    );
  }
}
