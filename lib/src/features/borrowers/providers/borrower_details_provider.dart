import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/borrowers/providers/borrowers_provider.dart';
import 'package:librarian_app/src/features/borrowers/providers/selected_borrower_provider.dart';

import '../data/borrower_model.dart';

final borrowerDetailsProvider = Provider<Future<BorrowerModel?>>((ref) async {
  final selectedBorrower = ref.watch(selectedBorrowerProvider);
  if (selectedBorrower == null) {
    return null;
  }

  final borrowers = await ref.watch(borrowersProvider);

  return borrowers.firstWhereOrNull((b) => b.id == selectedBorrower.id);
});
