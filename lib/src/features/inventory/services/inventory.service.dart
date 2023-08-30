import '../data/detailed_thing.model.dart';
import '../data/inventory.repo.dart';
import '../data/item.model.dart';
import '../data/thing.model.dart';

class InventoryService {
  final _repository = InventoryRepository();

  List<ThingModel> get cachedThings => _repository.things;

  Future<void> updateCachedThings() async {
    await _repository.refresh();
  }

  ThingModel? getCachedThing({required String? id}) {
    if (id == null || id.isEmpty || _repository.things.isEmpty) {
      return null;
    }

    return _repository.things.firstWhere((t) => t.id == id);
  }

  List<ThingModel> getCachedThings({String? filter}) {
    return _repository.getCachedThings(filter: filter);
  }

  Future<List<ThingModel>> getThings({String? filter}) async {
    return await _repository.getThings(filter: filter);
  }

  Future<DetailedThingModel> getThingDetails({required String id}) async {
    return await _repository.getThingDetails(id: id);
  }

  Future<ItemModel?> getItem({required int number}) async {
    return await _repository.getItem(number: number);
  }

  Future<ThingModel> createThing({
    required String name,
    String? spanishName,
  }) async {
    return await _repository.createThing(name: name, spanishName: spanishName);
  }

  Future<void> updateThing({
    required String thingId,
    String? name,
    String? spanishName,
    bool? hidden,
  }) async {
    return await _repository.updateThing(
      thingId: thingId,
      name: name,
      spanishName: spanishName,
      hidden: hidden,
    );
  }

  Future<void> createItems({
    required String thingId,
    required int quantity,
    required String? brand,
    required String? description,
    required double? estimatedValue,
  }) async {
    return await _repository.createItems(
      thingId: thingId,
      quantity: quantity,
      brand: brand,
      description: description,
      estimatedValue: estimatedValue,
    );
  }
}
