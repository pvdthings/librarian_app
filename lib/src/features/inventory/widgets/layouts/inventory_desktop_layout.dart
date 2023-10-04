import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/list_pane.widget.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/pane_header.widget.dart';
import 'package:librarian_app/src/features/common/widgets/search_field.widget.dart';
import 'package:librarian_app/src/features/inventory/providers/things_filter_provider.dart';

import '../inventory_details/inventory_details_pane.dart';
import '../inventory_list/inventory_list_view.dart';

class InventoryDesktopLayout extends ConsumerWidget {
  const InventoryDesktopLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        ListPane(
          header: PaneHeader(
            child: SearchField(
              onChanged: (value) {
                ref.read(thingsFilterProvider.notifier).state = value;
              },
              onClearPressed: () {
                ref.read(thingsFilterProvider.notifier).state = null;
              },
            ),
          ),
          child: const InventoryListView(),
        ),
        const Expanded(
          child: InventoryDetailsPane(),
        ),
      ],
    );
  }
}
