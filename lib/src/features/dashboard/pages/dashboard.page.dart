import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/widgets/dashboard/borrowers_desktop_layout.widget.dart';
import 'package:librarian_app/src/features/borrowers/widgets/searchable_borrowers_list.widget.dart';
import 'package:librarian_app/src/features/borrowers/widgets/needs_attention_view.widget.dart';
import 'package:librarian_app/src/features/inventory/data/inventory.vm.dart';
import 'package:librarian_app/src/features/inventory/widgets/dashboard/inventory_desktop_layout.widget.dart';
import 'package:librarian_app/src/features/inventory/pages/inventory_details.page.dart';
import 'package:librarian_app/src/features/inventory/widgets/searchable_inventory_list.widget.dart';
import 'package:librarian_app/src/features/inventory/widgets/create_thing_dialog.widget.dart';
import 'package:librarian_app/src/features/loans/pages/checkout.page.dart';
import 'package:librarian_app/src/features/loans/pages/loan_details.page.dart';
import 'package:librarian_app/src/features/loans/widgets/searchable_loans_list.widget.dart';
import 'package:librarian_app/src/features/loans/widgets/dashboard/loans_desktop_layout.widget.dart';
import 'package:librarian_app/src/utils/media_query.dart';
import 'package:provider/provider.dart';

import '../widgets/desktop_dashboard.widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _moduleIndex = 0;

  late final _inventory =
      Provider.of<InventoryViewModel>(context, listen: false);

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
      floatingActionButton: getFloatingActionButton(
        tooltip: 'New Loan',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CheckoutPage()),
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
      floatingActionButton: getFloatingActionButton(
        tooltip: 'Coming Soon',
        onPressed: () {},
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
      floatingActionButton: getFloatingActionButton(
        tooltip: 'New Thing',
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return CreateThingDialog(
                onCreate: (name, spanishName) {
                  _inventory
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
            // leading: IconButton(
            //   onPressed: () {
            //     final user = Provider.of<UserViewModel>(context, listen: false);
            //     user.signOut();
            //     Navigator.of(context).popAndPushNamed('/');
            //   },
            //   icon: const Icon(
            //     Icons.logout_rounded,
            //   ),
            // ),
          ),
          body: mobile
              ? module.mobileLayout
              : DesktopDashboard(
                  selectedIndex: _moduleIndex,
                  onDestinationSelected: (index) {
                    setState(() => _moduleIndex = index);
                  },
                  leading: module.floatingActionButton,
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
          floatingActionButton: mobile ? module.floatingActionButton : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
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
  required void Function() onPressed,
  String? tooltip,
}) {
  return FloatingActionButton.small(
    onPressed: onPressed,
    tooltip: tooltip,
    child: const Icon(
      Icons.add_rounded,
    ),
  );
}
