part of 'orders_bloc.dart';

abstract class OrdersEvent {
  const OrdersEvent();
}

class OrdersFetchRequested extends OrdersEvent {
  const OrdersFetchRequested();
}

class OrdersAddOrderRequested extends OrdersEvent {
  const OrdersAddOrderRequested({
    required this.date,
    required this.restaurantPlaceId,
    required this.restaurantName,
    required this.orderAddress,
    required this.totalOrderSum,
    required this.orderDeliveryFee,
  });

  final String date;
  final String restaurantPlaceId;
  final String restaurantName;
  final String orderAddress;
  final String totalOrderSum;
  final String orderDeliveryFee;
}

class OrdersDeleteOrderRequested extends OrdersEvent {
  const OrdersDeleteOrderRequested({
    required this.orderId,
  });

  final String orderId;
}

class OrdersRefreshRequested extends OrdersEvent {
  const OrdersRefreshRequested();
}
