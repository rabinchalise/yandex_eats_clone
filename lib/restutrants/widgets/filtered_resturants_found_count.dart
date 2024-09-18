import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_eats_clone/restutrants/filter/filter.dart';
import 'package:yandex_eats_clone/restutrants/resturants.dart';

class FilteredRestaurantsFoundCount extends StatelessWidget {
  const FilteredRestaurantsFoundCount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final filteredResturants =
        context.select((ResturantsBloc bloc) => bloc.state.filteredResturants);
    final resturantsCount = filteredResturants.length;

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Found $resturantsCount restaurants',
              style: context.bodyLarge
                  ?.copyWith(fontWeight: AppFontWeight.semiBold),
            ),
            const ResetFiltersButton(),
          ],
        ),
      ),
    );
  }
}
