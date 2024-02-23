import 'package:flutter/material.dart';

class ActionModel {
  const ActionModel({
    required this.title,
    required this.content,
    this.description,
    this.action,
  });

  final String title;
  final String? description;
  final Widget content;
  final Future<void> Function(DateTime dueDate)? action;
}
