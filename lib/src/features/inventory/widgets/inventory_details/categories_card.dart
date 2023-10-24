import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/common/widgets/details_card/card_body.dart';
import 'package:librarian_app/src/features/common/widgets/details_card/card_header.dart';
import 'package:librarian_app/src/features/common/widgets/details_card/details_card.dart';
import 'package:librarian_app/src/features/inventory/providers/edited_thing_details_providers.dart';

import '../../providers/thing_details_provider.dart';

class CategoriesCard extends ConsumerWidget {
  const CategoriesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.watch(thingDetailsProvider),
      builder: (context, snapshot) {
        final List<String> categories =
            snapshot.connectionState == ConnectionState.waiting
                ? []
                : ref.watch(categoriesProvider) ?? snapshot.data!.categories;

        return DetailsCard(
          header: const CardHeader(title: 'Categories'),
          showDivider: categories.isNotEmpty,
          body: categories.isNotEmpty
              ? CardBody(
                  child: Row(
                      children: categories
                          .map((c) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Chip(
                                  label: Text(c),
                                  onDeleted: () {
                                    ref
                                            .read(categoriesProvider.notifier)
                                            .state =
                                        categories
                                            .where((cat) => cat != c)
                                            .toList();
                                  },
                                ),
                              ))
                          .toList()),
                )
              : null,
        );
      },
    );
  }
}
