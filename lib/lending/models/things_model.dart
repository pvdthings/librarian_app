import 'package:flutter/material.dart';
import 'package:librarian_app/lending/api/lending_api.dart';

class ThingsModel extends ChangeNotifier {
  Future<Thing?> getOne({required int number}) async {
    try {
      final response = await LendingApi.fetchThing(number: number);
      final data = response.data;
      return Thing(
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

class Thing {
  final String id;
  final int number;
  final String name;
  bool available;

  Thing({
    required this.id,
    required this.number,
    required this.name,
    this.available = true,
  });
}
