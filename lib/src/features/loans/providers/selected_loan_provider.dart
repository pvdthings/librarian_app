import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/loans/data/loan.model.dart';

final selectedLoanProvider = StateProvider<LoanModel?>((ref) => null);
