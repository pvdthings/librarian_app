import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/providers/things_filter_provider.dart';
import 'package:librarian_app/src/features/inventory/providers/things_repository_provider.dart';

import '../models/thing_model.dart';

final thingsProvider = Provider<Future<List<ThingModel>>>((ref) async {
  final searchFilter = ref.watch(thingsFilterProvider);
  final repository = ref.watch(thingsRepositoryProvider);

  return await repository.getThings(filter: searchFilter);
});
