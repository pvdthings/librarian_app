import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/models/thing_model.dart';

class SelectedThing extends StateNotifier<ThingModel?> {
  SelectedThing(super.state);

  void select(ThingModel thing) => state = thing;

  void clear() => state = null;
}

final selectedThingProvider = StateNotifierProvider<SelectedThing, ThingModel?>(
  (ref) => SelectedThing(null),
);
