import 'package:librarian_app/src/features/common/data/lending_api.dart';

import 'detailed_thing.model.dart';
import 'thing.model.dart';

class InventoryRepository {
  List<ThingModel> things = [];

  Future<void> refresh() async {
    final response = await LendingApi.fetchThings();
    final objects = response.data as List;

    things = objects.map((e) => ThingModel.fromJson(e)).toList();
  }

  List<ThingModel> getCachedThings({String? filter}) {
    if (filter == null || filter.isEmpty) {
      return things;
    }

    return things
        .where((t) => t.name.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  Future<List<ThingModel>> getThings({String? filter}) async {
    await refresh();
    return getCachedThings(filter: filter);
  }

  Future<DetailedThingModel> getThingDetails({required String id}) async {
    final response = await LendingApi.fetchThing(id: id);
    return DetailedThingModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ThingModel> createThing({
    required String name,
    String? spanishName,
  }) async {
    final response = await LendingApi.createThing(
      name: name,
      spanishName: spanishName,
    );

    return ThingModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> updateThing({
    required String thingId,
    String? name,
    String? spanishName,
  }) async {
    await LendingApi.updateThing(
      thingId,
      name: name,
      spanishName: spanishName,
    );
  }

  Future<void> createItems({
    required String thingId,
    required int quantity,
    required String? brand,
    required String? description,
    required double? estimatedValue,
  }) async {
    await LendingApi.createInventoryItems(
      thingId,
      quantity: quantity,
      brand: brand,
      description: description,
      estimatedValue: estimatedValue,
    );
  }
}
