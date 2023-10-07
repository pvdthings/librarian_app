import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/common/data/lending_api.dart';

import 'borrower_model.dart';
import 'borrowers_mapper.dart';

class BorrowersRepository extends Notifier<Future<List<BorrowerModel>>> {
  @override
  Future<List<BorrowerModel>> build() async => await getBorrowers();

  Future<List<BorrowerModel>> getBorrowers() async {
    final response = await LendingApi.fetchBorrowers();
    return BorrowersMapper.map(response.data as List).toList();
  }

  Future<BorrowerModel?> getBorrower(String id) async {
    final borrowers = await state;
    return borrowers.firstWhereOrNull((b) => b.id == id);
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
