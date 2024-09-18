import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ResturantsLoadingView extends StatelessWidget {
  const ResturantsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverPadding(
      padding: EdgeInsets.only(top: AppSpacing.md),
      sliver: SliverFillRemaining(
        hasScrollBody: false,
        child: AppCircularProgressIndicator.adaptive(),
      ),
    );
  }
}
