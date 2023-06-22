import 'package:librarian_app/src/features/common/data/lending_api.dart';

import 'thing_model.dart';

class InventoryRepository {
  List<ThingModel> things = [];

  Future<void> refresh() async {
    final response = await LendingApi.fetchThings();
    final objects = response.data as List;

    things = objects.map((e) => ThingModel.fromJson(e)).toList();
  }
}
