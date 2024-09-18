import 'package:api/api.dart';
import 'package:stormberry/stormberry.dart';

class FindRestaurantById extends Query<DbResturantView?, QueryParams> {
  const FindRestaurantById();

  @override
  Future<DbResturantView?> apply(Session db, QueryParams params) async {
    final queryable = DbResturantViewQueryable();
    final tableName = queryable.tableAlias;
    final hasLocation = (params.values?.containsKey('lat') ?? false) &&
        (params.values?.containsKey('lng') ?? false);
    final where = hasLocation
        ? '''
earth_distance(
    ll_to_earth(@lat, @lng),
    ll_to_earth(latitude, longitude)
  ) <= 150000 AND place_id=@place_id '''
        : 'place_id=@place_id';
    final query = '''
      SELECT * FROM "$tableName"
      WHERE $where
    ''';

    final postgreSQLResult =
        await db.execute(Sql.named(query), parameters: params.values);

    final objects = postgreSQLResult
        .map((row) => queryable.decode(TypedMap(row.toColumnMap())))
        .toList();
    return objects.firstOrNull;
  }
}

class GetRestaurantsByLocation
    extends Query<List<DbResturantView>, QueryParams> {
  const GetRestaurantsByLocation();

  @override
  Future<List<DbResturantView>> apply(Session db, QueryParams params) async {
    final queryable = DbResturantViewQueryable();
    final tableName = queryable.tableAlias;
    final query = """
      SELECT * FROM "$tableName"
      WHERE earth_distance(
    ll_to_earth(@lat, @lng),
    ll_to_earth(latitude, longitude)
  ) <= 150000
      ${params.orderBy != null ? "ORDER BY ${params.orderBy}" : ""}
      ${params.limit != null ? "LIMIT ${params.limit}" : ""}
      ${params.offset != null ? "OFFSET ${params.offset}" : ""}
    """;

    final postgreSQLResult =
        await db.execute(Sql.named(query), parameters: params.values);

    return postgreSQLResult
        .map((row) => queryable.decode(TypedMap(row.toColumnMap())))
        .toList();
  }
}

class GetRestaurantsTagsByLocation extends Query<List<String>, QueryParams> {
  const GetRestaurantsTagsByLocation();

  @override
  Future<List<String>> apply(Session db, QueryParams params) async {
    final queryable = DbResturantViewQueryable();
    final tableName = queryable.tableAlias;
    final query = '''
      SELECT DISTINCT unnest(tags) FROM "$tableName"
      WHERE earth_distance(
    ll_to_earth(@lat, @lng),
    ll_to_earth(latitude, longitude)
  ) <= 150000
    ''';

    final postgreSQLResult =
        await db.execute(Sql.named(query), parameters: params.values);
    if (postgreSQLResult.isEmpty) return <String>[];
    return postgreSQLResult.map((row) => row[0]! as String).toList();
  }
}

class GetRestaurantsByTags extends Query<List<DbResturantView>, QueryParams> {
  const GetRestaurantsByTags();

  @override
  Future<List<DbResturantView>> apply(Session db, QueryParams params) async {
    final queryable = DbResturantViewQueryable();
    final tableName = queryable.tableAlias;
    final query = """
      SELECT * FROM "$tableName"
      WHERE tags::varchar[] && @tags::varchar[] 
        AND earth_distance(
      ll_to_earth(@lat, @lng),
      ll_to_earth(latitude, longitude)
    ) <= 150000
      ${params.orderBy != null ? "ORDER BY ${params.orderBy}" : ""}
      ${params.limit != null ? "LIMIT ${params.limit}" : ""}
      ${params.offset != null ? "OFFSET ${params.offset}" : ""}
    """;

    final postgreSQLResult =
        await db.execute(Sql.named(query), parameters: params.values);

    return postgreSQLResult
        .map((row) => queryable.decode(TypedMap(row.toColumnMap())))
        .toList();
  }
}

class SearchRelevantRestaurants
    extends Query<List<DbResturantView>, QueryParams> {
  const SearchRelevantRestaurants();

  @override
  Future<List<DbResturantView>> apply(Session db, QueryParams params) async {
    final queryable = DbResturantViewQueryable();
    final tableName = queryable.tableAlias;
    final query = """
      SELECT * FROM "$tableName"
      WHERE earth_distance(
    ll_to_earth(@lat, @lng),
    ll_to_earth(latitude, longitude)
  ) <= 150000 AND REPLACE(LOWER(name), ' ', '') LIKE REPLACE(LOWER(@term), ' ', '')
      ${params.orderBy != null ? "ORDER BY ${params.orderBy}" : ""}
      ${params.limit != null ? "LIMIT ${params.limit}" : ""}
      ${params.offset != null ? "OFFSET ${params.offset}" : ""}
    """;

    final postgreSQLResult =
        await db.execute(Sql.named(query), parameters: params.values);

    return postgreSQLResult
        .map((row) => queryable.decode(TypedMap(row.toColumnMap())))
        .toList();
  }
}

class GetPopularRestaurantsByLocation
    extends Query<List<DbResturantView>, QueryParams> {
  const GetPopularRestaurantsByLocation();

  @override
  Future<List<DbResturantView>> apply(Session db, QueryParams params) async {
    final queryable = DbResturantViewQueryable();
    final tableName = queryable.tableAlias;
    final query = """
      SELECT * FROM "$tableName"
      WHERE earth_distance(
    ll_to_earth(@lat, @lng),
    ll_to_earth(latitude, longitude)
  ) <= 150000 AND popular = true
      ${params.orderBy != null ? "ORDER BY ${params.orderBy}" : ""}
      ${params.limit != null ? "LIMIT ${params.limit}" : ""}
      ${params.offset != null ? "OFFSET ${params.offset}" : ""}
    """;

    final postgreSQLResult =
        await db.execute(Sql.named(query), parameters: params.values);

    return postgreSQLResult
        .map((row) => queryable.decode(TypedMap(row.toColumnMap())))
        .toList();
  }
}

class GetPopularRestaurantsByTags
    extends Query<List<DbResturantView>, QueryParams> {
  const GetPopularRestaurantsByTags();

  @override
  Future<List<DbResturantView>> apply(Session db, QueryParams params) async {
    final queryable = DbResturantViewQueryable();
    final tableName = queryable.tableAlias;
    final query = """
      SELECT * FROM "$tableName"
      WHERE earth_distance(
    ll_to_earth(@lat, @lng),
    ll_to_earth(latitude, longitude)
  ) <= 150000 AND tags::varchar[] && @tags::varchar[] AND popular = true
      ${params.orderBy != null ? "ORDER BY ${params.orderBy}" : ""}
      ${params.limit != null ? "LIMIT ${params.limit}" : ""}
      ${params.offset != null ? "OFFSET ${params.offset}" : ""}
    """;

    final postgreSQLResult =
        await db.execute(Sql.named(query), parameters: params.values);

    return postgreSQLResult
        .map((row) => queryable.decode(TypedMap(row.toColumnMap())))
        .toList();
  }
}

class FindRestaurantMenuById extends Query<List<DbmenuView>, QueryParams> {
  const FindRestaurantMenuById();

  @override
  Future<List<DbmenuView>> apply(Session db, QueryParams params) async {
    final queryable = DbmenuViewQueryable();
    final menuItemQueryable = DbmenuItemViewQueryable();
    final tableName = queryable.tableAlias;
    final menuItemTableName = menuItemQueryable.tableAlias;
    final query = '''
      SELECT *, items.data as items
      FROM "$tableName"
      LEFT JOIN (
        SELECT menu_id,
          to_jsonb(array_agg("$menuItemTableName".*)) as data
        FROM (${menuItemQueryable.query}) "$menuItemTableName"
        GROUP BY menu_id
      ) items
      ON id = items.menu_id
      WHERE resturant_place_id=@place_id
    ''';

    final postgreSQLResult =
        await db.execute(Sql.named(query), parameters: params.values);

    return postgreSQLResult
        .map((row) => queryable.decode(TypedMap(row.toColumnMap())))
        .toList();
  }
}
