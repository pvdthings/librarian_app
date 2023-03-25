import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'mappers/loans_mapper.dart';
import 'things_model.dart';

class LoansModel extends ChangeNotifier {
  static final List<Loan> _loans = [];

  String get _refreshToken =>
      Supabase.instance.client.auth.currentSession?.refreshToken ?? '';

  String get _accessToken =>
      Supabase.instance.client.auth.currentSession?.accessToken ?? '';

  Future<List<Loan>> getAll() async {
    // TODO: switch to production endpoint
    final response = await Dio().get(
      'http://localhost:3000/lending/loans',
      options: Options(
        contentType: 'application/json',
        headers: {
          'supabase-access-token': _accessToken,
          'supabase-refresh-token': _refreshToken,
        },
      ),
    );

    return LoansMapper.map(response.data as List).toList();
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
