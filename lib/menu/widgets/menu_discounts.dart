import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide MenuController;

import 'package:yandex_eats_clone/menu/menu.dart';

class MenuDiscounts extends StatelessWidget {
  const MenuDiscounts({
    required this.discounts,
    super.key,
  });

  final List<int> discounts;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final discount in discounts) DiscountCard(discount: discount),
          ],
        ),
      ),
    );
  }
}

class DiscountCard extends StatelessWidget {
  const DiscountCard({required this.discount, super.key});

  final int discount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      height: MenuController.discountHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade200,
            Colors.blue.shade300,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Colors.lightBlue.shade400,
                  Colors.lightBlue.shade100,
                ],
              ),
            ),
            child: const AppIcon(icon: LucideIcons.percent),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Text('Discount on several items'),
          const SizedBox(width: AppSpacing.sm),
          Text('$discount%', style: context.bodyLarge),
        ],
      ),
    );
  }
}
