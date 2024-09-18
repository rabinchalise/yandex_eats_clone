import 'package:app_ui/app_ui.dart' hide NumDurationExtensions;
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

/// Renders a widget containing a progress indicator that calls
/// [onPresented] when the item becomes visible.
class ResturantsLoaderItem extends StatefulWidget {
  const ResturantsLoaderItem({super.key, this.onPresented});

  /// A callback performed when the widget is presented.
  final VoidCallback? onPresented;

  @override
  State<ResturantsLoaderItem> createState() => _FeedLoaderItemState();
}

class _FeedLoaderItemState extends State<ResturantsLoaderItem> {
  @override
  void initState() {
    super.initState();
    Future.delayed(350.ms, () => widget.onPresented?.call());
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Center(
        child: AppCircularProgressIndicator(),
      ),
    );
  }
}
