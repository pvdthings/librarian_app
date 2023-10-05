import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/loans/data/loans_repository.dart';

final loansRepositoryProvider = Provider((_) => LoansRepository());
