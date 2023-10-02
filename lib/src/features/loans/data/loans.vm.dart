import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:librarian_app/src/features/common/data/lending_api.dart';
import 'package:librarian_app/src/features/inventory/data/inventory.repo.dart';
import 'package:librarian_app/src/features/inventory/models/item_model.dart';

import 'loan.model.dart';

class LoansViewModel extends ChangeNotifier {
  LoansViewModel() {
    refresh();
  }

  final _inventoryRepository = InventoryRepository();

  String? errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  List<LoanModel> _loans = [];
  List<LoanModel> get loans => _loans;

  List<LoanModel> filtered(String? filter) {
    if (filter == null || filter.isEmpty) {
      return _loans;
    }

    return _loans
        .where((l) =>
            l.borrower.name.toLowerCase().contains(filter.toLowerCase()) ||
            l.thing.name.toLowerCase().contains(filter.toLowerCase()) ||
            l.thing.number == int.tryParse(filter))
        .toList();
  }

  Future<void> refresh() async {
    isLoading = true;

    try {
      _loans = await getLoans();

      if (_selectedLoan != null) {
        _selectedLoan = _loans.firstWhere((l) => l.id == _selectedLoan!.id);
      }
    } on DioError {
      errorMessage =
          'Unable to refresh loans. You might not be connected to the internet.';
    } catch (_) {
      errorMessage = 'An unexpected error occurred.';
    }

    isLoading = false;
  }

  Future<ItemModel?> getInventoryItem({required int number}) async {
    return await _inventoryRepository.getItem(number: number);
  }

  Future<LoanModel?> getLoan({
    required String id,
    required String thingId,
  }) async {
    try {
      final response = await LendingApi.fetchLoan(id: id, thingId: thingId);
      return LoanModel.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      errorMessage = error.toString();
      return null;
    }
  }

  Future<List<LoanModel>> getLoans() async {
    final response = await LendingApi.fetchLoans();
    return (response.data as List).map((e) => LoanModel.fromJson(e)).toList();
  }

  LoanModel? _selectedLoan;
  LoanModel? get selectedLoan => _selectedLoan;

  set selectedLoan(value) {
    _selectedLoan = value;
    notifyListeners();
  }

  void clearSelectedLoan() => selectedLoan = null;

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
      errorMessage = error.toString();
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

    clearSelectedLoan();
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
