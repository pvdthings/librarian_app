import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/loans/providers/loans_repository_provider.dart';
import 'package:librarian_app/src/features/loans/providers/selected_loan_provider.dart';

import '../data/loan.model.dart';

final loanDetailsProvider = Provider<Future<LoanModel?>>((ref) async {
  final selectedLoan = ref.watch(selectedLoanProvider);
  if (selectedLoan == null) {
    return null;
  }

  final repository = ref.read(loansRepositoryProvider);

  return await repository.getLoan(
    id: selectedLoan.id,
    thingId: selectedLoan.thing.id,
  );
});
