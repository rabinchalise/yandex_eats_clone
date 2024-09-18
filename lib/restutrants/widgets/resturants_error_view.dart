import 'package:flutter/material.dart';

import 'package:yandex_eats_clone/error/error.dart';

class ResturantsErrorView extends StatelessWidget {
  const ResturantsErrorView({required this.onTryAgain, super.key});

  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: ErrorView(
        onTryAgain: onTryAgain,
      ),
    );
  }
}
