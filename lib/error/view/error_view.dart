import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, this.onTryAgain});
  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    return AppInfoSection(
      info: 'Something went wrong :(',
      onPressed: onTryAgain,
      buttonLabel: 'Try again',
      icon: LucideIcons.refreshCcw,
    );
  }
}
