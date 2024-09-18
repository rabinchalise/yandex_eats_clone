import 'dart:math';

import 'package:api/client.dart';
import 'package:app_ui/app_ui.dart' hide NumDurationExtensions;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:resturants_repository/resturants_repository.dart';
import 'package:shared/shared.dart';

import 'package:yandex_eats_clone/app/app.dart';
import 'package:yandex_eats_clone/menu/menu.dart';

class ResturantCard extends StatelessWidget {
  const ResturantCard({required this.restaurant, super.key});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final name = restaurant.name;
    final rating = restaurant.rating as double;
    final priceLevel = restaurant.priceLevel;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Tappable.faded(
        onTap: () => context.pushNamed(
          AppRoutes.menu.name,
          extra: MenuProps(restaurant: restaurant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ResturantImage(
                  resturant: restaurant,
                ),
                RestaurantDeliveryInfo(restaurant: restaurant),
                BookmarkButton(
                  restaurant: restaurant,
                ),
              ],
            ),
            Hero(
              tag: 'Menu$name',
              child: Text(
                name,
                style: context.titleLarge?.copyWith(
                  fontWeight: AppFontWeight.bold,
                ),
              ),
            ),
            Row(
              children: [
                AppIcon(
                  icon: LucideIcons.star,
                  color: rating <= 4.4 ? AppColors.grey : AppColors.green,
                ),
                const SizedBox(
                  width: AppSpacing.xs,
                ),
                Text(restaurant.formattedRating),
                const SizedBox(
                  width: AppSpacing.xs,
                ),
                if (restaurant.isRatingEnough)
                  Text(
                    restaurant.review,
                    style: context.bodyMedium?.apply(
                      color: restaurant.userRatingsTotal >= 30
                          ? context.customReversedAdaptiveColor(
                              light: AppColors.black,
                              dark: AppColors.white,
                            )
                          : context.customReversedAdaptiveColor(
                              light: AppColors.background,
                              dark: AppColors.brightGrey,
                            ),
                    ),
                  ),
                RestaurantPriceLevel(
                  priceLevel: priceLevel,
                ),
                const SizedBox(
                  width: AppSpacing.xs,
                ),
                Text(restaurant.formattedTags),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ResturantImage extends StatelessWidget {
  const ResturantImage({required this.resturant, super.key});

  final Restaurant resturant;

  @override
  Widget build(BuildContext context) {
    final (:thumbnailWidth, :thumbnailHeight, :imageUrl) = () {
      // If the image is not from Unsplash, return the original image URL.
      final unsplashUrlRegExp = RegExp(r'^https:\/\/images\.unsplash\.com\/');
      if (!unsplashUrlRegExp.hasMatch(resturant.imageUrl)) {
        return (
          thumbnailHeight: null,
          thumbnailWidth: null,
          imageUrl: resturant.imageUrl
        );
      }
      final screenWidth = context.screenWidth;
      final pixelRatio = context.devicePixelRatio;

      // AppSpacing.md * 2 is the horizontal padding of the screen.
      final thumbnailWidth =
          min(((screenWidth - (AppSpacing.md * 2)) * pixelRatio) ~/ 1, 1920);
      final thumbnailHeight = min((thumbnailWidth * (9 / 16)).toInt(), 1080);

      final widthRegExp = RegExp(r'w=\d+');
      final heightRegExp = RegExp(r'h=\d+');
      final imageUrl = resturant.imageUrl.replaceFirst(
        widthRegExp,
        'w=$thumbnailWidth',
      );
      final queryParameters = Uri.parse(imageUrl).queryParameters;
      final finalImageUrl = imageUrl.contains(heightRegExp)
          ? imageUrl.replaceFirst(
              heightRegExp,
              'h=$thumbnailHeight',
            )
          : Uri.parse(imageUrl).replace(
              queryParameters: {
                ...queryParameters,
                'h': '$thumbnailHeight',
              },
            ).toString();
      return (
        thumbnailHeight: thumbnailHeight,
        thumbnailWidth: thumbnailWidth,
        imageUrl: finalImageUrl,
      );
    }();
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ImageAttachmentThumbnail(
        imageUrl: resturant.imageUrl,
        memCacheHeight: thumbnailHeight,
        memCacheWidth: thumbnailWidth,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
      ),
    );
  }
}

class RestaurantPriceLevel extends StatelessWidget {
  const RestaurantPriceLevel({required this.priceLevel, super.key});
  final int priceLevel;

  @override
  Widget build(BuildContext context) {
    TextStyle? effectiveStyle(int level) {
      return context.bodyMedium?.apply(
        color: priceLevel >= level
            ? context.customReversedAdaptiveColor(
                light: AppColors.black,
                dark: AppColors.white,
              )
            : AppColors.grey,
      );
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: currency, style: effectiveStyle(1)),
          TextSpan(text: currency, style: effectiveStyle(2)),
          TextSpan(text: currency, style: effectiveStyle(3)),
        ],
      ),
    );
  }
}

class RestaurantDeliveryInfo extends StatelessWidget {
  const RestaurantDeliveryInfo({
    required this.restaurant,
    super.key,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final deliverByWalk = restaurant.deliveryTime < 8;

    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSpacing.md + AppSpacing.sm),
            bottomLeft: Radius.circular(AppSpacing.md + AppSpacing.sm),
            bottomRight: Radius.circular(AppSpacing.md + AppSpacing.sm),
          ),
          color: AppColors.black.withOpacity(.8),
        ),
        child: Row(
          children: [
            Icon(
              deliverByWalk ? Icons.directions_walk : Icons.directions_car,
              color: AppColors.white,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              restaurant.formattedDeliveryTime(),
              style: context.headlineSmall?.copyWith(
                fontWeight: AppFontWeight.regular,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookmarkButton extends StatelessWidget {
  const BookmarkButton({
    required this.restaurant,
    super.key,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<RestaurantsRepository>().bookmarkedRestaurants(),
      builder: (context, snapshot) {
        final bookmarkResturants = snapshot.data;
        final isBookmarked =
            bookmarkResturants?.contains(restaurant.placeId) ?? false;
        return Positioned(
          top: AppSpacing.sm,
          right: AppSpacing.sm,
          child: Tappable.scaled(
            onTap: () =>
                context.read<RestaurantsRepository>().bookmarkRestaurant(
                      placeId: restaurant.placeId,
                    ),
            throttle: true,
            throttleDuration: 350.ms,
            child: Container(
              height: 35,
              width: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.black.withOpacity(.8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: AppColors.white,
                size: AppSpacing.xlg,
              ),
            ),
          ),
        );
      },
    );
  }
}
