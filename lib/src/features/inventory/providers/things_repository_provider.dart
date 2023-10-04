import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/data/inventory_repository.dart';

final thingsRepositoryProvider = Provider((_) => InventoryRepository());
