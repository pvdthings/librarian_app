import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/views/dashboard/borrowers_desktop_layout.dart';
import 'package:librarian_app/src/features/borrowers/views/searchable_borrowers_list.dart';
import 'package:librarian_app/src/features/borrowers/widgets/needs_attention_view.dart';
import 'package:librarian_app/src/features/inventory/data/inventory_view_model.dart';
import 'package:librarian_app/src/features/inventory/views/dashboard/inventory_desktop_layout.dart';
import 'package:librarian_app/src/features/inventory/views/inventory_details_view.dart';
import 'package:librarian_app/src/features/inventory/views/searchable_inventory_list.dart';
import 'package:librarian_app/src/features/inventory/widgets/create_thing_dialog.dart';
import 'package:librarian_app/src/features/loans/views/checkout/checkout_page.dart';
import 'package:librarian_app/src/features/loans/views/loan_details_page.dart';
import 'package:librarian_app/src/features/loans/views/searchable_loans_list.dart';
import 'package:librarian_app/src/features/loans/views/dashboard/loans_desktop_layout.dart';
import 'package:librarian_app/src/utils/media_query.dart';
import 'package:provider/provider.dart';

import 'desktop_dashboard.dart';

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
            builder: (context) {
              return Scaffold(
                appBar: AppBar(title: Text(thing.name)),
                body: const Padding(
                  padding: EdgeInsets.all(16),
                  child: InventoryDetailsView(),
                ),
              );
            },
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
