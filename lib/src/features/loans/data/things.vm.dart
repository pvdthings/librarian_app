import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/data/lending_api.dart';

import 'thing.model.dart';

class ThingsViewModel extends ChangeNotifier {
  Future<ThingModel?> getOne({required int number}) async {
    try {
      final response = await LendingApi.fetchInventoryItem(number: number);
      final data = response.data;
      return ThingModel(
        id: data['id'] as String,
        number: data['number'] as int,
        name: data['name'] as String,
        available: data['available'] as bool,
      );
    } catch (error) {
      return null;
    }
  }
}
