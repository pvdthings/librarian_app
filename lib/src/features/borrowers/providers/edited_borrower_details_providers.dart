import 'package:flutter_riverpod/flutter_riverpod.dart';

final phoneProvider = StateProvider<String?>((ref) => null);

final emailProvider = StateProvider<String?>((ref) => null);

final unsavedChangesProvider = Provider<bool>((ref) {
  return ref.watch(phoneProvider) != null || ref.watch(emailProvider) != null;
});

class BorrowerDetailsEditor {
  BorrowerDetailsEditor(this.ref);

  final ProviderRef ref;

  Future<void> save(String id) async {
    // await ref.read(thingsRepositoryProvider.notifier).updateItem(id,
    //     brand: ref.read(brandProvider),
    //     condition: ref.read(conditionProvider),
    //     description: ref.read(descriptionProvider),
    //     estimatedValue: ref.read(estimatedValueProvider),
    //     hidden: ref.read(hiddenProvider));
    discardChanges();
  }

  void discardChanges() {
    ref.read(phoneProvider.notifier).state = null;
    ref.read(emailProvider.notifier).state = null;
  }
}

final borrowerDetailsEditorProvider =
    Provider((ref) => BorrowerDetailsEditor(ref));
