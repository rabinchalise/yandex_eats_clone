part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartAddItemRequested extends CartEvent {
  const CartAddItemRequested({
    required this.item,
    required this.restaurantPlaceId,
    this.amount,
  });

  final MenuItem item;
  final int? amount;
  final String restaurantPlaceId;

  @override
  List<Object?> get props => [item, restaurantPlaceId, amount];
}

class CartRemoveItemRequested extends CartEvent {
  const CartRemoveItemRequested({required this.item});

  final MenuItem item;

  @override
  List<Object?> get props => [item];
}

class CartItemIncreaseQuantityRequested extends CartEvent {
  const CartItemIncreaseQuantityRequested({required this.item, this.amount});

  final MenuItem item;
  final int? amount;

  @override
  List<Object?> get props => [item, amount];
}

class CartItemDecreaseQuantityRequested extends CartEvent {
  const CartItemDecreaseQuantityRequested({
    required this.item,
    this.goToMenu,
  });

  final MenuItem item;
  final ValueSetter<Restaurant?>? goToMenu;

  @override
  List<Object?> get props => [item, goToMenu];
}

final class CartClearRequested extends CartEvent {
  const CartClearRequested({this.goToMenu});

  final ValueSetter<Restaurant?>? goToMenu;

  @override
  List<Object?> get props => [goToMenu];
}

final class CartPlaceOrderRequested extends CartEvent {
  const CartPlaceOrderRequested({required this.orderAddress});

  final Address orderAddress;

  @override
  List<Object?> get props => [orderAddress];
}
