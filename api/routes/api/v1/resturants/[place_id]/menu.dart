import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';

Future<Response> onRequest(RequestContext context, String placeId) async {
  final db = await context.futureRead<Connection>();

  final menusView = await db.dbmenus.query(
    const FindRestaurantMenuById(),
    QueryParams(values: {'place_id': placeId}),
  );
  if (menusView.isEmpty) return Response().notFound();

  final menus = menusView.map(Menu.fromView).toList();
  return Response.json(body: {'menus': menus});
}
