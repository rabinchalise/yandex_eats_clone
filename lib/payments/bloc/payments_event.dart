part of 'payments_bloc.dart';

abstract class PaymentsEvent extends Equatable {
  const PaymentsEvent();

  @override
  List<Object?> get props => [];
}

class PaymentsFetchCardsRequested extends PaymentsEvent {
  const PaymentsFetchCardsRequested();
}

class PaymentsCreateCardRequested extends PaymentsEvent {
  const PaymentsCreateCardRequested({required this.card, this.onSuccess});

  final CreditCard card;
  final ValueSetter<CreditCard>? onSuccess;

  @override
  List<Object?> get props => [card, onSuccess];
}

class PaymentsUpdateRequested extends PaymentsEvent {
  const PaymentsUpdateRequested({required this.update});

  final PaymentsDataUpdate update;

  @override
  List<Object> get props => [update];
}

class PaymentsDeleteCardRequested extends PaymentsEvent {
  const PaymentsDeleteCardRequested({
    required this.number,
    this.onComplete,
  });

  final String number;
  final VoidCallback? onComplete;

  @override
  List<Object?> get props => [number];
}
