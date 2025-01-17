import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:yandex_eats_clone/app/routes/app_routes.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  void _drawerOptionAction(
    BuildContext context,
    DrawerOption name,
  ) =>
      switch (name) {
        DrawerOption.orders => context.pushNamed(AppRoutes.orders.name),
        DrawerOption.profile => context.pushNamed(AppRoutes.profile.name),
      };

  IconData _drawerOptionIcon(DrawerOption name) => switch (name) {
        DrawerOption.profile => LucideIcons.user,
        DrawerOption.orders => LucideIcons.shoppingCart,
      };

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.theme.canvasColor,
      width: context.screenWidth * 0.7,
      child: ListView(
        children: [
          DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Yandex',
                  style: context.headlineMedium,
                ),
                SizedBox(
                  height: 60,
                  width: 60,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ResizeImage(
                          Assets.images.papaBurgerLogo.provider(),
                          height: 180,
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Eats',
                  style: context.headlineMedium,
                ),
              ],
            ),
          ),
          ...DrawerOption.values.map((option) {
            return ListTile(
              horizontalTitleGap: AppSize.sm,
              onTap: () {
                Scaffold.of(context).closeDrawer();
                _drawerOptionAction(context, option);
              },
              leading: Icon(
                _drawerOptionIcon(option),
                color: context.theme.colorScheme.onSurface,
              ),
              title: Text(option.name),
            );
          }),
        ],
      ),
    );
  }
}
