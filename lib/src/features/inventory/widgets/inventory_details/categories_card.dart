import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/common/widgets/details_card/card_body.dart';
import 'package:librarian_app/src/features/common/widgets/details_card/card_header.dart';
import 'package:librarian_app/src/features/common/widgets/details_card/details_card.dart';

import '../../providers/thing_details_provider.dart';

class CategoriesCard extends ConsumerWidget {
  const CategoriesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.watch(thingDetailsProvider),
      builder: (context, snapshot) {
        final categories = snapshot.connectionState == ConnectionState.waiting
            ? []
            : snapshot.data!.categories;

        return DetailsCard(
          header: const CardHeader(title: 'Categories'),
          showDivider: categories.isNotEmpty,
          body: categories.isNotEmpty
              ? CardBody(
                  child: Row(
                      children: categories
                          .map((c) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Chip(label: Text(c)),
                              ))
                          .toList()),
                )
              : null,
        );
      },
    );
  }
}
