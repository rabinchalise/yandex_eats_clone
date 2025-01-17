import 'package:api/client.dart';
import 'package:app_ui/app_ui.dart' hide NumDurationExtensions;
import 'package:flutter/material.dart' hide MenuController;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:resturants_repository/resturants_repository.dart';
import 'package:shared/shared.dart';
import 'package:yandex_eats_clone/app/app.dart';
import 'package:yandex_eats_clone/cart/cart.dart';
import 'package:yandex_eats_clone/menu/menu.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({required this.props, super.key});

  final MenuProps props;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MenuBloc(
        restaurant: props.restaurant,
        resturantsRepository: context.read<RestaurantsRepository>(),
      )..add(const MenuFetchRequested()),
      child: MenuView(props: props),
    );
  }
}

class MenuView extends StatefulWidget {
  const MenuView({required this.props, super.key});

  final MenuProps props;

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView>
    with SingleTickerProviderStateMixin {
  Restaurant get restaurant => widget.props.restaurant;

  late MenuController _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = MenuController();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menus = context.select((MenuBloc bloc) => bloc.state.menus);

    return DefaultTabController(
      length: menus.length,
      child: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _bloc
              ..init(menus)
              ..tabController = DefaultTabController.of(context);
          });
          return AppScaffold(
            bottomNavigationBar: MenuBottomAppBar(restaurant: restaurant),
            top: false,
            body: CustomScrollView(
              controller: _bloc.scrollController,
              slivers: [
                ListenableBuilder(
                  listenable: Listenable.merge(
                    [
                      _bloc.isScrolledNotifier,
                      _bloc.preferredSizedNotifier,
                      _bloc.colorChangeNotifier,
                    ],
                  ),
                  builder: (context, _) {
                    return SliverAppBar(
                      titleSpacing: AppSpacing.xlg,
                      pinned: true,
                      expandedHeight: 300,
                      forceElevated: true,
                      automaticallyImplyLeading: false,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.md),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.customReversedAdaptiveColor(
                              light: AppColors.white,
                              dark: context.theme.canvasColor,
                            ),
                          ),
                          child: Tappable.faded(
                            onTap: context.pop,
                            child: Icon(
                              _bloc.isScrolledNotifier.value
                                  ? LucideIcons.x
                                  : Icons.adaptive.arrow_back,
                            ),
                          ),
                        ),
                      ),
                      flexibleSpace: AnnotatedRegion<SystemUiOverlayStyle>(
                        value: context.isIOS
                            ? SystemUiOverlayTheme.adaptiveOSSystemBarTheme(
                                light: !_bloc.colorChangeNotifier.value,
                                persistLight: context.isDark,
                              )
                            : SystemUiOverlayTheme
                                .adaptiveAndroidTransparentSystemBarTheme(
                                light: !_bloc.colorChangeNotifier.value,
                                persistLight: context.isDark,
                              ),
                        child: FlexibleSpaceBar(
                          expandedTitleScale: 2.2,
                          centerTitle: false,
                          background: MenuAppBarBackgroundImage(
                            imageUrl: restaurant.imageUrl,
                            placeId: restaurant.placeId,
                          ),
                          title: Hero(
                            tag: 'Menu${restaurant.name}',
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: _bloc.preferredSizedNotifier.value,
                              ),
                              child: Text(
                                restaurant.name,
                                maxLines:
                                    _bloc.colorChangeNotifier.value ? 1 : 2,
                                style: context.titleMedium?.copyWith(
                                  fontWeight: AppFontWeight.bold,
                                  color: _bloc.colorChangeNotifier.value
                                      ? context.customReversedAdaptiveColor(
                                          dark: AppColors.white,
                                          light: AppColors.black,
                                        )
                                      : AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize:
                            Size.fromHeight(_bloc.preferredSizedNotifier.value),
                        child: CircularContainer(
                          height: _bloc.preferredSizedNotifier.value,
                        ),
                      ),
                    );
                  },
                ),
                if (menus.isNotEmpty) ...[
                  ListenableBuilder(
                    listenable: _bloc,
                    builder: (context, _) {
                      if (_bloc.tabs.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        );
                      }
                      return MenuTabBar(controller: _bloc);
                    },
                  ),
                  ListenableBuilder(
                    listenable: _bloc,
                    builder: (context, child) {
                      return MenuDiscounts(discounts: _bloc.discounts);
                    },
                  ),
                  for (int i = 0;
                      i < menus.map((e) => e.category).length;
                      i++) ...[
                    MenuSectionHeader(
                      categoryName: menus[i].category,
                      categoryHeight: _bloc.categoryHeight,
                    ),
                    MenuSectionItems(
                      menu: menus[i],
                    ),
                  ],
                ] else
                  const SliverFillRemaining(
                    child: AppCircularProgressIndicator.adaptive(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MenuBottomAppBar extends StatelessWidget {
  const MenuBottomAppBar({required this.restaurant, super.key});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final cartEmpty = state.isCartEmpty;
        final isFromSameRestaurant =
            state.restaurant?.placeId == restaurant.placeId;

        if (cartEmpty || !isFromSameRestaurant) {
          return const SizedBox.shrink();
        }

        return const FadeAnimation(
          intervalEnd: 0.2,
          child: AppBottomBar(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.xlg),
              topRight: Radius.circular(AppSpacing.xlg),
            ),
            children: [
              DeliveryInfoBox(),
              SizedBox(height: AppSpacing.md),
              OrderInfoButton(),
            ],
          ),
        );
      },
    );
  }
}

class DeliveryInfoBox extends StatelessWidget {
  const DeliveryInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.select((CartBloc bloc) => bloc.state);
    final defaultDeliveryFee =
        context.select((CartBloc bloc) => bloc.state.formattedDeliveryFee);

    return Tappable(
      onTap: () => context.pushNamed(AppRoutes.cart.name),
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned(
              left: 0,
              child: AppIcon(
                icon: LucideIcons.carTaxiFront,
                iconSize: AppSize.md,
              ),
            ),
            if (cart.isDeliveryFree)
              DiscountPrice(
                defaultPrice: defaultDeliveryFee,
                discountPrice: 0.currencyFormat(decimalDigits: 0),
                forDeliveryFee: true,
                hasDiscount: false,
              )
            else
              Column(
                children: [
                  Text(
                    'Delivery ${cart.formattedOrderDeliveryFee}',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'To Free delivery ${cart.sumLeftToFreeDelivery}',
                    textAlign: TextAlign.center,
                    style: context.bodyMedium?.apply(color: AppColors.green),
                  ),
                ],
              ),
            Positioned(
              right: 0,
              child: AppIcon(icon: Icons.adaptive.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderInfoButton extends StatelessWidget {
  const OrderInfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.select((CartBloc bloc) => bloc.state);
    final restaurant = context.select((CartBloc bloc) => bloc.state.restaurant);

    return Tappable.faded(
      backgroundColor: AppColors.deepBlue,
      borderRadius: AppSpacing.sm,
      onTap: () => context.pushNamed(AppRoutes.cart.name),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                child: LimitedBox(
                  maxWidth: 120,
                  child: Text(
                    restaurant?.formattedDeliveryTime() ?? '',
                    textAlign: TextAlign.center,
                    style: context.bodyMedium
                        ?.apply(color: context.theme.colorScheme.surface),
                  ),
                ),
              ),
              Text(
                'Order',
                style: context.bodyLarge
                    ?.copyWith(color: context.theme.colorScheme.surface),
              ),
              Positioned(
                right: 0,
                child: Text(
                  cart.formattedTotalDelivery(),
                  style: context.bodyMedium?.apply(
                    color: context.customReversedAdaptiveColor(
                      dark: AppColors.emphasizeDarkGrey,
                      light: AppColors.brightGrey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularContainer extends StatelessWidget {
  const CircularContainer({
    required this.height,
    super.key,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 2.ms,
      height: height,
      decoration: BoxDecoration(
        color: context.theme.canvasColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.lg * 2),
        ),
      ),
    );
  }
}
