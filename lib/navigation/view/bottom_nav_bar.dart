import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_eats_clone/app/app.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final items = mainNavigationBarItems(homeLabel: 'Home', cartLabel: 'Cart');
    return BottomNavigationBar(
      iconSize: AppSize.xlg,
      currentIndex: navigationShell.currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: context.theme.colorScheme.primary,
      onTap: (index) {
        if (index == 0) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        } else if (index == 1) {
          context.pushNamed(AppRoutes.cart.name);
        }
      },
      items: items
          .map(
            (item) => BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
              tooltip: item.tooltip,
            ),
          )
          .toList(),
    );
  }
}
