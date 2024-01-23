import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:librarian_app/src/api/lending_api.dart';
import 'package:librarian_app/src/features/loans/models/loan_model.dart';

class LoansRepository extends Notifier<Future<List<LoanModel>>> {
  @override
  Future<List<LoanModel>> build() async => await getLoans();

  Future<LoanModel?> getLoan({
    required String id,
    required String thingId,
  }) async {
    try {
      final response = await LendingApi.fetchLoan(id: id, thingId: thingId);
      return LoanModel.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      return null;
    }
  }

  Future<List<LoanModel>> getLoans() async {
    final response = await LendingApi.fetchLoans();
    return (response.data as List).map((e) => LoanModel.fromJson(e)).toList();
  }

  Future<bool> openLoan({
    required String borrowerId,
    required List<String> thingIds,
    required DateTime dueBackDate,
  }) async {
    final dateFormat = DateFormat('yyyy-MM-dd');
    try {
      await LendingApi.createLoan(NewLoan(
        borrowerId: borrowerId,
        thingIds: thingIds,
        checkedOutDate: dateFormat.format(DateTime.now()),
        dueBackDate: dateFormat.format(dueBackDate),
      ));
    } catch (error) {
      return false;
    }

    ref.invalidateSelf();
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

    ref.invalidateSelf();
  }

  Future<void> updateLoan({
    required String loanId,
    required String thingId,
    required DateTime dueBackDate,
    String? notes,
  }) async {
    final dateFormat = DateFormat('yyyy-MM-dd');

    await LendingApi.updateLoan(UpdatedLoan(
      loanId: loanId,
      thingId: thingId,
      dueBackDate: dateFormat.format(dueBackDate),
      notes: notes,
    ));

    ref.invalidateSelf();
  }
}
