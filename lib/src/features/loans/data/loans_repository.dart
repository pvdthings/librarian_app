import 'package:intl/intl.dart';
import 'package:librarian_app/src/features/common/data/lending_api.dart';
import 'package:librarian_app/src/features/loans/data/loan.model.dart';

class LoansRepository {
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
  }
}
