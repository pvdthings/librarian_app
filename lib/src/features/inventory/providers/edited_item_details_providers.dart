import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/providers/things_repository_provider.dart';

final brandProvider = StateProvider<String?>((ref) => null);

final descriptionProvider = StateProvider<String?>((ref) => null);

final hiddenProvider = StateProvider<bool?>((ref) => null);

final estimatedValueProvider = StateProvider<double?>((ref) => null);

final conditionProvider = StateProvider<String?>((ref) => null);

final unsavedChangesProvider = Provider<bool>((ref) {
  return ref.watch(brandProvider) != null ||
      ref.watch(descriptionProvider) != null ||
      ref.watch(hiddenProvider) != null ||
      ref.watch(estimatedValueProvider) != null ||
      ref.watch(conditionProvider) != null;
});

class ItemDetailsEditor {
  ItemDetailsEditor(this.ref);

  final ProviderRef ref;

  Future<void> save(String id) async {
    await ref.read(thingsRepositoryProvider.notifier).updateItem(id,
        brand: ref.read(brandProvider),
        condition: ref.read(conditionProvider),
        description: ref.read(descriptionProvider),
        estimatedValue: ref.read(estimatedValueProvider),
        hidden: ref.read(hiddenProvider));
    discardChanges();
  }

  void discardChanges() {
    ref.read(brandProvider.notifier).state = null;
    ref.read(conditionProvider.notifier).state = null;
    ref.read(descriptionProvider.notifier).state = null;
    ref.read(estimatedValueProvider.notifier).state = null;
    ref.read(hiddenProvider.notifier).state = null;
  }
}

final itemDetailsEditorProvider = Provider((ref) => ItemDetailsEditor(ref));
