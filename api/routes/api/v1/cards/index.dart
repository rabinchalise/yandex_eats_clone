import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response().methodNotAllowed();
  }
  final user = context.read<RequestUser>();
  if (user.isAnonymous) return Response().unauthorized();

  final db = await context.futureRead<Connection>();

  final creditCardsView = await db.dbcreditCards.query(
    const FindUserCreditCards(),
    QueryParams(values: {'user_id': user.id}),
  );
  final creditCards = creditCardsView.map(CreditCard.fromView).toList();
  return Response.json(body: {'credit_cards': creditCards});
}
