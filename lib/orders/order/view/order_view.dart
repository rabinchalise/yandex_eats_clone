import 'package:api/client.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orders_repository/orders_repository.dart';
import 'package:resturants_repository/resturants_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yandex_eats_clone/app/app.dart';
import 'package:yandex_eats_clone/error/error.dart';
import 'package:yandex_eats_clone/menu/menu.dart';
import 'package:yandex_eats_clone/orders/order/order.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderBloc(
        orderId: orderId,
        ordersRepository: context.read<OrdersRepository>(),
        restaurantsRepository: context.read<RestaurantsRepository>(),
        userRepository: context.read<UserRepository>(),
      )..add(const OrderFetchRequested()),
      child: const OrderView(),
    );
  }
}

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  @override
  Widget build(BuildContext context) {
    final order = context.select((OrderBloc bloc) => bloc.state.order);
    final isError =
        context.select((OrderBloc bloc) => bloc.state.status.isError);
    final isLoading =
        context.select((OrderBloc bloc) => bloc.state.status.isLoading);

    return AppScaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            forceElevated: true,
            title: Text(
              order?.status.toJson() ?? '',
              style: context.headlineSmall,
            ),
            centerTitle: false,
            elevation: 2,
            pinned: true,
            floating: true,
          ),
          Builder(
            builder: (_) {
              if (isLoading) return const OrderDetailsLoading();
              if (isError) return const OrderDetailsGenericError();
              if (order == null) return const OrderNotFoundView();
              return const OrderDetailsView();
            },
          ),
        ],
      ),
    );
  }
}

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final order = context.select((OrderBloc bloc) => bloc.state.order!);
    final restaurant =
        context.select((OrderBloc bloc) => bloc.state.restaurant);

    final orderId = order.id;
    final totalSum = order.totalOrderSum.currencyFormat();
    final date = order.date;
    final restaurantName = order.restaurantName;
    final orderMenuItems = order.items;
    final deliveryFee = order.deliveryFee.currencyFormat();
    final costOfGoods = order.items.isEmpty
        ? '0'
        : order.items
            .map((e) => e.price * e.quantity)
            .reduce((sum, current) => sum + current)
            .currencyFormat();
    final orderAddress = order.address;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      sliver: SliverList.list(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Order №$orderId',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.bodyLarge,
            ),
            subtitle: Text(date),
            subtitleTextStyle: context.bodyMedium?.apply(color: AppColors.grey),
          ),
          ListTile(
            onTap: restaurant == null
                ? () => context.showInfoDialog(
                      title: 'Restaurant not found',
                      content:
                          'Restaurant is not found in your current location.',
                    )
                : () => context.pushNamed(
                      AppRoutes.menu.name,
                      extra: MenuProps(restaurant: restaurant),
                    ),
            contentPadding: EdgeInsets.zero,
            title: Text(
              'From restaurant',
              style: context.bodyMedium?.apply(color: AppColors.grey),
            ),
            subtitle: Text(restaurantName),
            subtitleTextStyle: context.bodyLarge,
            trailing: const Text('Go to >'),
            leadingAndTrailingTextStyle: context.bodyLarge,
          ),
          const Padding(
            padding: EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.md),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OrderActionButton(
                text: 'Hide',
                icon: LucideIcons.eyeOff,
                onTap: () {
                  context.read<OrderBloc>().add(const OrderDeleteRequested());
                  context.pop();
                },
              ),
              OrderActionButton(
                text: 'Support',
                icon: LucideIcons.messageCircleQuestion,
                onTap: () {},
              ),
              OrderActionButton(
                text: 'Repeat',
                icon: LucideIcons.rotateCw,
                size: 32,
                onTap: () {},
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: Text(
                  'Order list',
                  style: context.headlineSmall,
                ),
              ),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),
              ...ListTile.divideTiles(
                context: context,
                tiles: orderMenuItems.map(
                  (item) => OrderMenuItemTile(
                    key: ValueKey(item.id),
                    item: item,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xlg),
            ],
          ),
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ListTile.divideTiles(
                  context: context,
                  tiles: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Row(
                        children: [
                          Text(
                            'Delivery and payment',
                            style: context.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Cost of goods',
                        style: context.bodyLarge,
                      ),
                      trailing: Text(costOfGoods),
                      leadingAndTrailingTextStyle: context.bodyLarge,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Delivery fee',
                        style: context.bodyLarge,
                      ),
                      subtitle: Text(orderAddress),
                      subtitleTextStyle:
                          context.bodyMedium?.apply(color: AppColors.grey),
                      trailing: Text(deliveryFee),
                      leadingAndTrailingTextStyle: context.bodyLarge,
                    ),
                  ],
                ).toList(),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Overall',
                  style: context.bodyLarge
                      ?.copyWith(fontWeight: AppFontWeight.bold),
                ),
                trailing: Text(totalSum),
                leadingAndTrailingTextStyle: context.bodyLarge
                    ?.copyWith(fontWeight: AppFontWeight.semiBold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderDetailsGenericError extends StatelessWidget {
  const OrderDetailsGenericError({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: ErrorView(),
    );
  }
}

class OrderNotFoundView extends StatelessWidget {
  const OrderNotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Order is not found.',
            style: context.headlineMedium
                ?.copyWith(fontWeight: AppFontWeight.semiBold),
          ),
          ShadButton(
            onPressed: context.pop,
            child: Text(
              '<- Back',
              style: context.bodyLarge?.apply(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDetailsLoading extends StatelessWidget {
  const OrderDetailsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: AppCircularProgressIndicator(),
    );
  }
}
