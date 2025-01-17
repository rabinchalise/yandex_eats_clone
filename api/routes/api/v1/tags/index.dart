import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response().methodNotAllowed();
  }

  final lat = context.query('lat').doubleTryParse();
  final lng = context.query('lng').doubleTryParse();

  if (lat == null || lng == null) return Response().badRequest();

  final db = await context.futureRead<Connection>();

  final tagsView = await db.dbResturants.query(
    const GetRestaurantsTagsByLocation(),
    QueryParams(values: {'lat': lat, 'lng': lng}),
  );

  final tags = tagsView.map(Tag.fromName).toList();
  return Response.json(body: {'tags': tags});
}
