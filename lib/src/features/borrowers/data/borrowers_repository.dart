import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/borrowers/models/payment_model.dart';
import 'package:librarian_app/src/features/common/data/lending_api.dart';

import '../models/borrower_model.dart';

class BorrowersRepository extends Notifier<Future<List<BorrowerModel>>> {
  @override
  Future<List<BorrowerModel>> build() async => await getBorrowers();

  Future<List<BorrowerModel>> getBorrowers() async {
    final response = await LendingApi.fetchBorrowers();
    return (response.data as List)
        .map((json) => BorrowerModel.fromJson(json))
        .toList();
  }

  Future<BorrowerModel?> getBorrower(String id) async {
    final borrowers = await state;
    return borrowers.firstWhereOrNull((b) => b.id == id);
  }

  Future<List<PaymentModel>> getPayments(String borrowerId) async {
    final response = await LendingApi.fetchPayments(borrowerId: borrowerId);
    return (response.data as List)
        .map((e) => PaymentModel.fromJson(e))
        .toList();
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
      return false;
    }

    ref.invalidateSelf();
    return true;
  }
}
