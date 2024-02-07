import 'package:flutter/material.dart';

class DesktopDashboard extends StatelessWidget {
  const DesktopDashboard({
    super.key,
    required this.child,
    this.leading,
    this.selectedIndex = 0,
    this.onDestinationSelected,
  });

  final Widget child;
  final Widget? leading;
  final int selectedIndex;
  final void Function(int)? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
          labelType: NavigationRailLabelType.selected,
          leading: leading,
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.handshake_rounded),
              label: Text('Loans'),
              padding: EdgeInsets.symmetric(vertical: 8),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.people_rounded),
              label: Text('Borrowers'),
              padding: EdgeInsets.symmetric(vertical: 8),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.build_rounded),
              label: Text('Things'),
              padding: EdgeInsets.symmetric(vertical: 8),
            ),
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            onDestinationSelected?.call(index);
          },
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 8, bottom: 8),
            child: child,
          ),
        ),
      ],
    );
  }
}
