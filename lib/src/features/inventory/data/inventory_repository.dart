import 'package:flutter/foundation.dart';
import 'package:librarian_app/src/features/common/data/lending_api.dart';
import 'package:librarian_app/src/features/common/services/image_service.dart';
import 'package:librarian_app/src/features/inventory/models/updated_image_model.dart';

import '../models/detailed_thing_model.dart';
import '../models/item_model.dart';
import '../models/thing_model.dart';

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

  Future<ItemModel?> getItem({required int number}) async {
    try {
      final response = await LendingApi.fetchInventoryItem(number: number);
      return ItemModel.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
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
    bool? hidden,
    UpdatedImageModel? image,
  }) async {
    if (image != null && image.bytes == null) {
      await deleteThingImage(thingId: thingId);
    }

    await LendingApi.updateThing(
      thingId,
      name: name,
      spanishName: spanishName,
      hidden: hidden,
      image: await _convert(image),
    );
  }

  Future<ImageDTO?> _convert(UpdatedImageModel? updatedImage) async {
    if (updatedImage == null || updatedImage.bytes == null || kDebugMode) {
      return null;
    }

    final result = await ImageService().uploadImage(
      bytes: updatedImage.bytes!,
      type: updatedImage.type!,
    );

    return ImageDTO(url: result.url);
  }

  Future<void> deleteThingImage({required String thingId}) async {
    await LendingApi.deleteThingImage(thingId);
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