import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yandex_eats_clone/restutrants/resturants.dart';
import 'package:yandex_eats_clone/restutrants/tag/view/tag_slider.dart';

final _bucket = PageStorageBucket();

class ResturantsPage extends StatelessWidget {
  const ResturantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: _bucket,
      child: const ResturantsView(),
    );
  }
}

class ResturantsView extends StatelessWidget {
  const ResturantsView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ResturantsBloc>().add(const ResturantsRefreshRequested());
      },
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      displacement: 30,
      strokeWidth: 3,
      backgroundColor: AppColors.white,
      color: AppColors.black,
      child: BlocBuilder<ResturantsBloc, ResturantsState>(
        builder: (context, state) {
          final isLoading = state.status.isLoading;
          final resturants = state.resturantPage.resturants;
          final isFailure = state.status.isFailure;
          final isFiltered = state.status.isFiltered;
          final currentPage = state.resturantPage.page;
          return CustomScrollView(
            key: const PageStorageKey<String>('resturantsPage'),
            slivers: [
              const RestaurantsAppBar(),
              if (isLoading) const ResturantsLoadingView(),
              if (currentPage == 0 && isFailure)
                ResturantsErrorView(
                  onTryAgain: () => context
                      .read<ResturantsBloc>()
                      .add(const ResturantsFetchRequested()),
                ),
              if (!isLoading && !isFailure) ...[
                if (!isFiltered) ...[
                  if (resturants.isEmpty)
                    const ResturantsEmptyView()
                  else ...[
                    const RestaurantsSectionHeader(text: 'All restaurants'),
                    const TagsSlider(),
                    const ResturantListView(),
                  ],
                ] else ...[
                  const TagsSlider(),
                  const SliverToBoxAdapter(
                    child: Divider(
                      height: 1,
                      indent: AppSpacing.md,
                      endIndent: AppSpacing.md,
                    ),
                  ),
                  const FilteredRestaurantsFoundCount(),
                  const FilteredRestaurantsView(),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}
