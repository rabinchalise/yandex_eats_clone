// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

const headerPhoto =
    'https://i.postimg.cc/TYmTcNQx/Whats-App-Image-2023-05-31-at-18-33-47.jpg';
const searchFoodLabel = 'Search food...';
const searchLocationLabel = 'Search';
const quickSearchLabel = 'Quick Search';
const fakeStreet = 'Olive Street 54/12';

enum DrawerOption {
  profile('Profile'),
  orders('Orders');

  const DrawerOption(this.name);

  final String name;
}

/// Navigation bar items
List<NavBarItem> mainNavigationBarItems({
  required String homeLabel,
  required String cartLabel,
}) =>
    <NavBarItem>[
      NavBarItem(icon: LucideIcons.chefHat, label: homeLabel),
      NavBarItem(icon: LucideIcons.shoppingCart, label: cartLabel),
    ];

class NavBarItem {
  NavBarItem({
    this.icon,
    this.label,
    this.child,
  });

  final String? label;
  final Widget? child;
  final IconData? icon;

  String? get tooltip => label;
}
