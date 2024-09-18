import 'dart:convert';
import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(
      statusCode: HttpStatus.methodNotAllowed,
      body: 'Method not allowed',
    );
  }
  final db = await context.futureRead<Connection>();

  final file = File('data/resturants.json');
  final resturantsJsonString = await file.readAsString();
  final resturantsJson = (jsonDecode(resturantsJsonString) as List<dynamic>)
      .cast<Map<String, dynamic>>();

  final restaurantInserts = resturantsJson
      .map(FakeRestaurant.fromJson)
      .map(
        (restaurant) => FakeRestaurantInsert(
          restaurant: DbResturantInsertRequest(
            placeId: restaurant.placeId,
            name: restaurant.name,
            latitude: restaurant.latitude,
            longitude: restaurant.longitude,
            businessStatus: restaurant.businessStatus,
            tags: restaurant.tags,
            imageUrl: restaurant.imageUrl,
            rating: restaurant.rating,
            userRatingsTotal: int.tryParse(restaurant.userRatingsTotal) ?? 0,
            openNow: restaurant.openNow,
            popular: restaurant.popular,
            priceLevel: restaurant.priceLevel,
          ),
          menuCategories: restaurant.menu.categories
              .map(
                (menuCategory) => DBMenuInsertRequest(
                  category: menuCategory.category,
                  resturantPlaceId: menuCategory.restaurantPlaceId,
                ),
              )
              .toList(),
          menus: restaurant.menu.items
              .map(
                (menu) => (int id) => menu
                    .map(
                      (item) => DBMenuItemInsertRequest(
                        name: item.name,
                        description: item.description,
                        imageUrl: item.imageUrl,
                        price: item.price,
                        discount: item.discount,
                        menuId: id,
                      ),
                    )
                    .toList(),
              )
              .toList(),
        ),
      )
      .toList();
  await db.dbResturants
      .insertMany(restaurantInserts.map((e) => e.restaurant).toList())
      .whenComplete(() async {
    for (final insert in restaurantInserts) {
      final categoriesId = await db.dbmenus.insertMany(insert.menuCategories);
      for (var i = 0; i < categoriesId.length; i++) {
        final categoryId = categoriesId[i];
        final menuItems = insert.menus[i](categoryId);
        await db.dbmenuItems.insertMany(menuItems);
      }
    }
  });
  return Response(statusCode: HttpStatus.created);
}
