import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/data/lending_api.dart';

import 'borrower.model.dart';
import 'borrowers_mapper.dart';

class BorrowersViewModel extends ChangeNotifier {
  BorrowersViewModel() {
    refresh();
  }

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  set errorMessage(value) {
    _errorMessage = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  List<BorrowerModel> _borrowers = [];
  List<BorrowerModel> get borrowers => _borrowers;

  List<BorrowerModel> filtered(String filter) {
    if (filter.isEmpty) {
      return _borrowers;
    }

    return _borrowers
        .where((b) => b.name.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  BorrowerModel? _selectedBorrower;
  BorrowerModel? get selectedBorrower => _selectedBorrower;

  set selectedBorrower(value) {
    _selectedBorrower = value;
    notifyListeners();
  }

  void clearSelectedBorrower() => selectedBorrower = null;

  Future<void> refresh() async {
    isLoading = true;

    try {
      _borrowers = await getBorrowers();

      if (_selectedBorrower != null) {
        _selectedBorrower =
            _borrowers.firstWhere((b) => b.id == _selectedBorrower!.id);
      }
    } on DioError {
      _errorMessage =
          'Unable to refresh borrowers. You might not be connected to the internet.';
    } catch (_) {
      _errorMessage = 'An unexpected error occurred.';
    }

    isLoading = false;
  }

  Future<List<BorrowerModel>> getBorrowers() async {
    final response = await LendingApi.fetchBorrowers();
    return BorrowersMapper.map(response.data as List).toList();
  }

  Future<bool> recordCashPayment({
    required String borrowerId,
    required double cash,
  }) async {
    try {
      await LendingApi.recordCashPayment(
        cash: cash,
        borrowerId: borrowerId,
      );
    } catch (error) {
      errorMessage = error.toString();
      return false;
    }

    await refresh();
    return true;
  }
}
