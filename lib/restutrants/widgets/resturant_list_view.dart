import 'package:api/client.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_eats_clone/network/network.dart';
import 'package:yandex_eats_clone/restutrants/resturants.dart';

class ResturantListView extends StatelessWidget {
  const ResturantListView({this.resturants = const [], super.key});
  final List<Restaurant> resturants;

  @override
  Widget build(BuildContext context) {
    final resturnatsPage =
        context.select((ResturantsBloc bloc) => bloc.state.resturantPage);
    final isFailure =
        context.select((ResturantsBloc bloc) => bloc.state.status.isFailure);
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
      ),
      sliver: resturants.isEmpty
          ? SliverList.builder(
              itemCount: resturnatsPage.resturants.length,
              itemBuilder: (context, index) {
                final resturants = resturnatsPage.resturants;
                final totalRestaurants = resturnatsPage.totalResturants;
                final hasMoreRestaurants = resturnatsPage.hasMore;

                final restaurant = resturants[index];

                return _buildItem(
                  context: context,
                  index: index,
                  totalRestaurants: totalRestaurants,
                  hasMoreRestaurants: hasMoreRestaurants,
                  isFailure: isFailure,
                  restaurant: restaurant,
                );
              },
            )
          : SliverList.builder(
              itemCount: resturants.length,
              itemBuilder: (context, index) {
                final resturant = resturants[index];
                final openNow = resturant.openNow;

                final card = ResturantCard(
                  key: ValueKey(resturant.placeId),
                  restaurant: resturant,
                );

                if (openNow) return card;
                return Opacity(
                  opacity: 0.6,
                  child: card,
                );
              },
            ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required int index,
    required int totalRestaurants,
    required bool hasMoreRestaurants,
    required bool isFailure,
    required Restaurant restaurant,
  }) {
    if (index + 1 == totalRestaurants && hasMoreRestaurants) {
      if (isFailure) {
        if (!hasMoreRestaurants) return const SizedBox.shrink();
        return NetworkError(
          onRetry: () {
            context
                .read<ResturantsBloc>()
                .add(const ResturantsFetchRequested());
          },
        );
      } else {
        return Padding(
          padding:
              EdgeInsets.only(top: totalRestaurants == 0 ? AppSpacing.md : 0),
          child: ResturantsLoaderItem(
            key: ValueKey(index),
            onPresented: () => hasMoreRestaurants
                ? context
                    .read<ResturantsBloc>()
                    .add(const ResturantsFetchRequested())
                : null,
          ),
        );
      }
    }
    final openNow = restaurant.openNow;

    final card = ResturantCard(
      key: ValueKey(restaurant.placeId),
      restaurant: restaurant,
    );
    if (openNow) return card;
    return Opacity(opacity: 0.6, child: card);
  }
}
