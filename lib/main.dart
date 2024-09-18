import 'package:api/client.dart';
import 'package:firebase_authentication_client/firebase_authentication_client.dart';
import 'package:location_repository/location_repository.dart';
import 'package:orders_repository/orders_repository.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:resturants_repository/resturants_repository.dart';
import 'package:shared/shared.dart';
import 'package:stripe_payments_client/stripe_payments_client.dart';
import 'package:token_storage/token_storage.dart';
import 'package:user_repository/user_repository.dart';
import 'package:web_socket_client/web_socket_client.dart';
import 'package:yandex_eats_clone/app/app.dart';
import 'package:yandex_eats_clone/bootstrap.dart';

void main() async {
  await bootstrap((sharedPreferences) async {
    final tokenStorage = InMemoryTokenStorage();
    final firebaseAuthenticationClient = FirebaseAuthenticationClient(
      tokenStorage: tokenStorage,
    );
    final appDio = AppDio(tokenProvider: tokenStorage.readToken);
    final apiClient = YandexEatsApiClient.localhost(
      dio: appDio,
    );

    final persistentStorage =
        PersistentStorage(sharedPreferences: sharedPreferences);
    final persistentListStorage =
        PersistentListStorage(sharedPreferences: sharedPreferences);

    final userStorage = UserStorage(storage: persistentStorage);
    final userRepository = UserRepository(
      authenticationClient: firebaseAuthenticationClient,
      userStorage: userStorage,
    );
    final resturantStroage = ResturantsStorage(storage: persistentListStorage);

    final resturantsRepository = RestaurantsRepository(
      apiClient: apiClient,
      storage: resturantStroage,
    );
    final locationRepository =
        LocationRepository(httpClient: appDio.httpClient);
    final stripePaymentsClient = StripePaymentsClient(appDio: appDio);

    final paymentRepository = PaymentsRepository(
      apiClient: apiClient,
      paymentsClient: stripePaymentsClient,
    );

    final timerStorage = InMemoryTimersStorage();
    final backgroundTimer = BackgroundTimer(
      apiClient: apiClient,
      timersStorage: timerStorage,
    );

    final ordersReository = OrdersRepository(
      apiClient: apiClient,
      backgroundTimer: backgroundTimer,
      wsOrdersStatus: WebSocket(
        Uri.parse('uri'),
      ),
    );
    return App(
      userRepository: userRepository,
      user: await userRepository.user.first,
      locationRepository: locationRepository,
      resturantsRepository: resturantsRepository,
      paymentsRepository: paymentRepository,
      ordersRepository: ordersReository,
    );
  });
}
