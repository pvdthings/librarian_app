import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers_view_model.dart';
import 'package:librarian_app/src/features/common/data/lending_api.dart';

import 'loans_mapper.dart';
import 'things_model.dart';

class LoansViewModel extends ChangeNotifier {
  LoansViewModel() {
    refresh();
  }

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  List<LoanModel> _loans = [];
  List<LoanModel> get loans => _loans;

  Future<void> refresh() async {
    isLoading = true;
    try {
      _loans = await getLoans();
    } catch (error) {
      _errorMessage = error.toString();
    }

    isLoading = false;
  }

  Future<List<LoanModel>> getLoans() async {
    final response = await LendingApi.fetchLoans();
    return LoansMapper.map(response.data as List).toList();
  }

  LoanModel? _selectedLoan;
  LoanModel? get selectedLoan => _selectedLoan;

  set selectedLoan(value) {
    _selectedLoan = value;
    notifyListeners();
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
    await refresh();
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

    await refresh();
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

    await refresh();
  }
}

class LoanModel {
  final String id;
  final Thing thing;
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
