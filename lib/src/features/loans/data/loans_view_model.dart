import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:librarian_app/src/features/common/data/lending_api.dart';

import 'loan_model.dart';
import 'loans_mapper.dart';

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

    if (_selectedLoan != null) {
      _selectedLoan = _loans.firstWhere((l) => l.id == _selectedLoan!.id);
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

  Future<bool> openLoan({
    required String borrowerId,
    required List<String> thingIds,
    required String checkedOutDate,
    required String dueBackDate,
  }) async {
    try {
      await LendingApi.createLoan(NewLoan(
        borrowerId: borrowerId,
        thingIds: thingIds,
        checkedOutDate: checkedOutDate,
        dueBackDate: dueBackDate,
      ));
      await refresh();
    } catch (error) {
      _errorMessage = error.toString();
      return false;
    }

    return true;
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
