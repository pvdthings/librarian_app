import 'package:librarian_app/src/features/common/data/lending_api.dart';

import 'detailed_thing_model.dart';
import 'thing_model.dart';

class InventoryRepository {
  List<ThingModel> things = [];

  Future<void> refresh() async {
    final response = await LendingApi.fetchThings();
    final objects = response.data as List;

    things = objects.map((e) => ThingModel.fromJson(e)).toList();
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
