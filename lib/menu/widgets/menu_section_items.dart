import 'package:api/client.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yandex_eats_clone/menu/menu.dart';

class MenuSectionItems extends StatelessWidget {
  const MenuSectionItems({
    required this.menu,
    super.key,
  });

  final Menu menu;

  @override
  Widget build(BuildContext context) {
    final restaurantPlaceId =
        context.select((MenuBloc bloc) => bloc.state.restaurant.placeId);
    final isOpened =
        context.select((MenuBloc bloc) => bloc.state.restaurant.openNow);

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      sliver: SliverGrid.builder(
        itemCount: menu.items.length,
        itemBuilder: (context, index) {
          final item = menu.items[index];

          return MenuItemCard(
            key: ValueKey(item.id),
            item: item,
            restaurantPlaceId: restaurantPlaceId,
            isOpened: isOpened,
          );
        },
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisExtent: 330,
        ),
      ),
    );
  }
}
