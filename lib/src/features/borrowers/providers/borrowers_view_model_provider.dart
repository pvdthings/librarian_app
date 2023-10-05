import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers.vm.dart';

final borrowersViewModelProvider = Provider((ref) => BorrowersViewModel());
