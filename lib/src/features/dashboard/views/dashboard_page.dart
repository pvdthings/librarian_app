import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/authentication/data/user_view_model.dart';
import 'package:librarian_app/src/features/borrowers/views/dashboard/borrowers_desktop_layout.dart';
import 'package:librarian_app/src/features/borrowers/views/searchable_borrowers_list.dart';
import 'package:librarian_app/src/features/borrowers/widgets/needs_attention_view.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CheckoutPage()),
          );
        },
        child: const Icon(
          Icons.add_rounded,
        ),
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
    const DashboardModule(
      title: 'Inventory',
      desktopLayout: Center(child: Text('Inventory Desktop Layout')),
      mobileLayout: Center(child: Text('Inventory Mobile Layout')),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    final module = _modules[_moduleIndex];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: mobile
              ? AppBar(
                  title: Text(module.title),
                  leading: IconButton(
                    onPressed: () {
                      final user =
                          Provider.of<UserViewModel>(context, listen: false);
                      user.signOut();
                      Navigator.of(context).popAndPushNamed('/');
                    },
                    icon: const Icon(
                      Icons.logout_rounded,
                    ),
                  ),
                )
              : null,
          body: mobile
              ? module.mobileLayout
              : DesktopDashboard(
                  selectedIndex: _moduleIndex,
                  onDestinationSelected: (index) {
                    setState(() => _moduleIndex = index);
                  },
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
                        label: "Inventory",
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
