import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_eats_clone/app/app.dart';
import 'package:yandex_eats_clone/auth/auth.dart';
import 'package:yandex_eats_clone/cart/view/cart_page.dart';
import 'package:yandex_eats_clone/home/home.dart';
import 'package:yandex_eats_clone/map/map.dart';
import 'package:yandex_eats_clone/menu/menu.dart';
import 'package:yandex_eats_clone/orders/order/order.dart';
import 'package:yandex_eats_clone/orders/orders.dart';
import 'package:yandex_eats_clone/profile/profile.dart';
import 'package:yandex_eats_clone/restutrants/resturants.dart';
import 'package:yandex_eats_clone/search/search.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  GoRouter router(AppBloc appBloc) => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: AppRoutes.auth.route,
        routes: [
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: AppRoutes.auth.route,
            name: AppRoutes.auth.name,
            builder: (context, state) => const AuthPage(),
          ),
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: AppRoutes.googleMap.route,
            name: AppRoutes.googleMap.name,
            builder: (context, state) => const GoogleMapPage(),
          ),
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: AppRoutes.searchLocation.route,
            name: AppRoutes.searchLocation.name,
            builder: (context, state) => const SearchLocationAutoCompletePage(),
          ),
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: AppRoutes.cart.route,
            name: AppRoutes.cart.name,
            builder: (context, state) => const CartPage(),
          ),
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: AppRoutes.profile.route,
            name: AppRoutes.profile.name,
            builder: (context, state) => const ProfileView(),
            routes: [
              GoRoute(
                path: AppRoutes.updateEmail.name,
                name: AppRoutes.updateEmail.name,
                builder: (context, state) => const UserUpdateEmailForm(),
              ),
            ],
          ),
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: AppRoutes.orders.route,
            name: AppRoutes.orders.name,
            builder: (context, state) => const OrdersView(),
            routes: [
              GoRoute(
                path: '${AppRoutes.order.name}/:order_id',
                name: AppRoutes.order.name,
                builder: (context, state) => OrderPage(
                  orderId: state.pathParameters['order_id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: AppRoutes.search.route,
            name: AppRoutes.search.name,
            builder: (context, state) => const SearchPage(),
          ),
          StatefulShellRoute.indexedStack(
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state, navigationShell) {
              return HomeView(navigationShell: navigationShell);
            },
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: AppRoutes.resturants.route,
                    name: AppRoutes.resturants.name,
                    builder: (context, state) => const ResturantsPage(),
                    routes: [
                      GoRoute(
                        parentNavigatorKey: _rootNavigatorKey,
                        path: AppRoutes.menu.name,
                        name: AppRoutes.menu.name,
                        builder: (context, state) {
                          final props = state.extra! as MenuProps;
                          return MenuPage(props: props);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/go-to-cart',
                    redirect: (context, state) => null,
                  ),
                ],
              ),
            ],
          ),
        ],
        redirect: (context, state) {
          final authenticated = appBloc.state.status == AppStatus.authenticated;
          final authenticating = state.matchedLocation == AppRoutes.auth.route;
          final hasLocation = !appBloc.state.location.isUndefined;
          final isInResturants =
              state.matchedLocation == AppRoutes.resturants.route;

          if (isInResturants && !authenticated) return AppRoutes.auth.route;
          if (!authenticated) return AppRoutes.auth.route;
          if (!hasLocation && authenticating) return AppRoutes.googleMap.route;
          if (authenticating && authenticated) {
            return AppRoutes.resturants.route;
          }
          return null;
        },
        refreshListenable: GoRouterAppBlocRefreshStream(appBloc.stream),
      );
}

/// {@template go_router_refresh_stream}
/// A [ChangeNotifier] that notifies listeners when a [Stream] emits a value.
/// This is used to rebuild the UI when the [AppBloc] emits a new state.
/// {@endtemplate}
class GoRouterAppBlocRefreshStream extends ChangeNotifier {
  /// {@macro go_router_refresh_stream}
  GoRouterAppBlocRefreshStream(Stream<AppState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
