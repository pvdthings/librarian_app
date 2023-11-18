import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/borrowers/widgets/layouts/borrowers_desktop_layout.dart';
import 'package:librarian_app/src/features/borrowers/widgets/borrowers_list/searchable_borrowers_list.dart';
import 'package:librarian_app/src/features/borrowers/widgets/needs_attention_view.dart';
import 'package:librarian_app/src/features/dashboard/widgets/create_menu_item.dart';
import 'package:librarian_app/src/features/inventory/providers/things_repository_provider.dart';
import 'package:librarian_app/src/features/inventory/widgets/layouts/inventory_desktop_layout.dart';
import 'package:librarian_app/src/features/inventory/pages/inventory_details_page.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_list/searchable_inventory_list.dart';
import 'package:librarian_app/src/features/inventory/widgets/dialogs/create_thing_dialog.dart';
import 'package:librarian_app/src/features/loans/pages/checkout_page.dart';
import 'package:librarian_app/src/features/loans/pages/loan_details_page.dart';
import 'package:librarian_app/src/features/loans/widgets/loans_list/searchable_loans_list.dart';
import 'package:librarian_app/src/features/loans/widgets/layouts/loans_desktop_layout.dart';
import 'package:librarian_app/src/utils/media_query.dart';

import '../widgets/desktop_dashboard.widget.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DashboardPageState();
  }
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  int _moduleIndex = 0;

  late final List<DashboardModule> _modules = [
    DashboardModule(
      title: 'Loans',
      desktopLayout: const LoansDesktopLayout(),
      mobileLayout: SearchableLoansList(
        onLoanTapped: (loan) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoanDetailsPage(loan),
            ),
          );
        },
      ),
    ),
    DashboardModule(
      title: 'Borrowers',
      desktopLayout: const BorrowersDesktopLayout(),
      mobileLayout: SearchableBorrowersList(
        onTapBorrower: (borrower) {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return Scaffold(
              appBar: AppBar(title: Text(borrower.name)),
              body: NeedsAttentionView(borrower: borrower),
            );
          }));
        },
      ),
    ),
    DashboardModule(
      title: 'Things',
      desktopLayout: const InventoryDesktopLayout(),
      mobileLayout: SearchableInventoryList(
        onThingTapped: (thing) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const InventoryDetailsPage(),
          ));
        },
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    final module = _modules[_moduleIndex];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Text(module.title),
            centerTitle: mobile,
            elevation: 0,
            scrolledUnderElevation: isMobile(context) ? 1 : 0,
          ),
          body: mobile
              ? module.mobileLayout
              : DesktopDashboard(
                  selectedIndex: _moduleIndex,
                  onDestinationSelected: (index) {
                    setState(() => _moduleIndex = index);
                  },
                  leading: getFloatingActionButton(
                    context: context,
                    ref: ref,
                    isMobile: mobile,
                  ),
                  child: module.desktopLayout,
                ),
          bottomNavigationBar: mobile
              ? SafeArea(
                  child: BottomNavigationBar(
                    currentIndex: _moduleIndex,
                    onTap: (index) => setState(() {
                      _moduleIndex = index;
                    }),
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.handshake_rounded),
                        label: "Loans",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.people_rounded),
                        label: "Borrowers",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.build_rounded),
                        label: "Things",
                      ),
                    ],
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                  ),
                )
              : null,
          floatingActionButton: mobile
              ? getFloatingActionButton(
                  context: context,
                  ref: ref,
                  isMobile: mobile,
                )
              : null,
        );
      },
    );
  }
}

class DashboardModule {
  const DashboardModule({
    required this.title,
    required this.desktopLayout,
    required this.mobileLayout,
    this.floatingActionButton,
  });

  final String title;
  final Widget desktopLayout;
  final Widget mobileLayout;
  final Widget? floatingActionButton;
}

FloatingActionButton getFloatingActionButton({
  required BuildContext context,
  required WidgetRef ref,
  required bool isMobile,
}) {
  return FloatingActionButton(
    mini: !isMobile,
    child: const Icon(Icons.add),
    onPressed: () {
      final RenderBox renderBox = context.findRenderObject()! as RenderBox;
      final RenderBox overlay =
          Overlay.of(context).context.findRenderObject()! as RenderBox;

      showMenu(
        context: context,
        position: RelativeRect.fromRect(
          Rect.fromPoints(
            renderBox.localToGlobal(Offset.zero, ancestor: overlay),
            renderBox.localToGlobal(
              renderBox.size.bottomRight(Offset.zero),
              ancestor: overlay,
            ),
          ),
          Offset.zero & overlay.size,
        ),
        color: Theme.of(context).primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        items: [
          createMenuItem(
            context: context,
            text: 'New Loan',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CheckoutPage()),
              );
            },
          ),
          createMenuItem(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return CreateThingDialog(
                    onCreate: (name, spanishName) {
                      ref
                          .read(thingsRepositoryProvider.notifier)
                          .createThing(name: name, spanishName: spanishName)
                          .then((value) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${value.name} created'),
                          ),
                        );
                      });
                    },
                  );
                },
              );
            },
            text: 'New Thing',
            context: context,
          ),
        ],
      );
    },
  );
}
