import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/loans/providers/loans_repository_provider.dart';
import 'package:librarian_app/src/features/loans/providers/selected_loan_provider.dart';

import '../models/loan_model.dart';

final loanDetailsProvider = Provider<Future<LoanModel?>>((ref) async {
  final selectedLoan = ref.watch(selectedLoanProvider);
  if (selectedLoan == null) {
    return null;
  }

  final loans = await ref.watch(loansRepositoryProvider);
  return loans.firstWhereOrNull((loan) => loan.id == selectedLoan.id);
});