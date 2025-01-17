import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response().methodNotAllowed();
  }
  final db = await context.futureRead<Connection>();

  final user = context.read<RequestUser>();
  if (user.isAnonymous) return Response().unauthorized();

  final ordersView = await db.dborderDetailses.queryDborderDetailses(
    QueryParams(
      where: 'user_id = @user_id',
      values: {'user_id': user.id},
    ),
  );
  final orders = ordersView.map(Order.fromView).toList();
  return Response.json(body: {'orders': orders});
}
