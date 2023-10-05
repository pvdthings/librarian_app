import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/loans/data/loan.model.dart';
import 'package:librarian_app/src/features/loans/providers/loans_filter_provider.dart';
import 'package:librarian_app/src/features/loans/providers/loans_repository_provider.dart';

final loansProvider = Provider<Future<List<LoanModel>>>((ref) async {
  final searchFilter = ref.watch(loansFilterProvider);
  final repository = ref.read(loansRepositoryProvider);

  final loans = await repository.getLoans();
  if (searchFilter == null) {
    return loans;
  }

  return loans
      .where((l) =>
          l.borrower.name.toLowerCase().contains(searchFilter.toLowerCase()) ||
          l.thing.name.toLowerCase().contains(searchFilter.toLowerCase()) ||
          l.thing.number.toString() == searchFilter)
      .toList();
});
