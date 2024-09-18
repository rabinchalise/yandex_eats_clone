import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_repository/location_repository.dart';
import 'package:orders_repository/orders_repository.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:resturants_repository/resturants_repository.dart';

import 'package:user_repository/user_repository.dart';
import 'package:yandex_eats_clone/app/app.dart';
import 'package:yandex_eats_clone/cart/bloc/cart_bloc.dart';
import 'package:yandex_eats_clone/map/map.dart';
import 'package:yandex_eats_clone/orders/orders.dart';
import 'package:yandex_eats_clone/payments/payments.dart';
import 'package:yandex_eats_clone/restutrants/resturants.dart';

class App extends StatelessWidget {
  const App({
    required this.userRepository,
    required this.user,
    required this.locationRepository,
    required this.resturantsRepository,
    required this.paymentsRepository,
    required this.ordersRepository,
    super.key,
  });

  final UserRepository userRepository;
  final User user;
  final LocationRepository locationRepository;
  final RestaurantsRepository resturantsRepository;
  final PaymentsRepository paymentsRepository;
  final OrdersRepository ordersRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: userRepository,
        ),
        RepositoryProvider.value(
          value: locationRepository,
        ),
        RepositoryProvider.value(
          value: resturantsRepository,
        ),
        RepositoryProvider.value(
          value: paymentsRepository,
        ),
        RepositoryProvider.value(
          value: ordersRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AppBloc(
              user: user,
              userRepository: userRepository,
            ),
          ),
          BlocProvider(
            create: (context) => ResturantsBloc(
              resturantsRepository: resturantsRepository,
              userRepository: userRepository,
            ),
          ),
          BlocProvider(
            create: (context) => LocationBloc(
              userRepository: userRepository,
            ),
          ),
          BlocProvider(
            create: (context) => CartBloc(
              resturantsRepository: resturantsRepository,
              userRepository: userRepository,
              ordersRepository: ordersRepository,
            ),
          ),
          BlocProvider(
            create: (context) => PaymentsBloc(
              paymentsRepository: paymentsRepository,
            ),
          ),
          BlocProvider(
            create: (context) => SelectedCardCubit(
              paymentsRepository: paymentsRepository,
            ),
          ),
          BlocProvider(
            create: (context) => OrdersBloc(
              userRepository: userRepository,
              ordersRepository: ordersRepository,
            ),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}
