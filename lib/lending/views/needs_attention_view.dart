import 'package:flutter/material.dart';
import 'package:librarian_app/views/placeholder_view.dart';

class NeedsAttentionView extends StatelessWidget {
  const NeedsAttentionView({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: "Ineligible borrower reasons & QR code to pay dues",
    );
  }
}
