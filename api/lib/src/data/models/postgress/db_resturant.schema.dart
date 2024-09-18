// ignore_for_file: annotate_overrides

part of 'db_resturant.dart';

extension DbResturantRepositories on Session {
  DbResturantRepository get dbResturants => DbResturantRepository._(this);
}

abstract class DbResturantRepository
    implements
        ModelRepository,
        ModelRepositoryInsert<DbResturantInsertRequest>,
        ModelRepositoryUpdate<DbResturantUpdateRequest>,
        ModelRepositoryDelete<String> {
  factory DbResturantRepository._(Session db) = _DbResturantRepository;

  Future<DbResturantView?> queryDbResturant(String placeId);
  Future<List<DbResturantView>> queryDbResturants([QueryParams? params]);
}

class _DbResturantRepository extends BaseRepository
    with
        RepositoryInsertMixin<DbResturantInsertRequest>,
        RepositoryUpdateMixin<DbResturantUpdateRequest>,
        RepositoryDeleteMixin<String>
    implements DbResturantRepository {
  _DbResturantRepository(super.db) : super(tableName: 'Resturant', keyName: 'place_id');

  @override
  Future<DbResturantView?> queryDbResturant(String placeId) {
    return queryOne(placeId, DbResturantViewQueryable());
  }

  @override
  Future<List<DbResturantView>> queryDbResturants([QueryParams? params]) {
    return queryMany(DbResturantViewQueryable(), params);
  }

  @override
  Future<void> insert(List<DbResturantInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.execute(
      Sql.named(
          'INSERT INTO "Resturant" ( "place_id", "name", "popular", "latitude", "longitude", "business_status", "tags", "image_url", "rating", "user_ratings_total", "price_level", "open_now" )\n'
          'VALUES ${requests.map((r) => '( ${values.add(r.placeId)}:text, ${values.add(r.name)}:text, ${values.add(r.popular)}:boolean, ${values.add(r.latitude)}:float8, ${values.add(r.longitude)}:float8, ${values.add(r.businessStatus)}:text, ${values.add(r.tags)}:_text, ${values.add(r.imageUrl)}:text, ${values.add(r.rating)}:float8, ${values.add(r.userRatingsTotal)}:int8, ${values.add(r.priceLevel)}:int8, ${values.add(r.openNow)}:boolean )').join(', ')}\n'),
      parameters: values.values,
    );
  }

  @override
  Future<void> update(List<DbResturantUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.execute(
      Sql.named('UPDATE "Resturant"\n'
          'SET "name" = COALESCE(UPDATED."name", "Resturant"."name"), "popular" = COALESCE(UPDATED."popular", "Resturant"."popular"), "latitude" = COALESCE(UPDATED."latitude", "Resturant"."latitude"), "longitude" = COALESCE(UPDATED."longitude", "Resturant"."longitude"), "business_status" = COALESCE(UPDATED."business_status", "Resturant"."business_status"), "tags" = COALESCE(UPDATED."tags", "Resturant"."tags"), "image_url" = COALESCE(UPDATED."image_url", "Resturant"."image_url"), "rating" = COALESCE(UPDATED."rating", "Resturant"."rating"), "user_ratings_total" = COALESCE(UPDATED."user_ratings_total", "Resturant"."user_ratings_total"), "price_level" = COALESCE(UPDATED."price_level", "Resturant"."price_level"), "open_now" = COALESCE(UPDATED."open_now", "Resturant"."open_now")\n'
          'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.placeId)}:text::text, ${values.add(r.name)}:text::text, ${values.add(r.popular)}:boolean::boolean, ${values.add(r.latitude)}:float8::float8, ${values.add(r.longitude)}:float8::float8, ${values.add(r.businessStatus)}:text::text, ${values.add(r.tags)}:_text::_text, ${values.add(r.imageUrl)}:text::text, ${values.add(r.rating)}:float8::float8, ${values.add(r.userRatingsTotal)}:int8::int8, ${values.add(r.priceLevel)}:int8::int8, ${values.add(r.openNow)}:boolean::boolean )').join(', ')} )\n'
          'AS UPDATED("place_id", "name", "popular", "latitude", "longitude", "business_status", "tags", "image_url", "rating", "user_ratings_total", "price_level", "open_now")\n'
          'WHERE "Resturant"."place_id" = UPDATED."place_id"'),
      parameters: values.values,
    );
  }
}

class DbResturantInsertRequest {
  DbResturantInsertRequest({
    required this.placeId,
    required this.name,
    required this.popular,
    required this.latitude,
    required this.longitude,
    required this.businessStatus,
    required this.tags,
    required this.imageUrl,
    required this.rating,
    required this.userRatingsTotal,
    required this.priceLevel,
    required this.openNow,
  });

  final String placeId;
  final String name;
  final bool popular;
  final double latitude;
  final double longitude;
  final String businessStatus;
  final List<String> tags;
  final String imageUrl;
  final double rating;
  final int userRatingsTotal;
  final int priceLevel;
  final bool openNow;
}

class DbResturantUpdateRequest {
  DbResturantUpdateRequest({
    required this.placeId,
    this.name,
    this.popular,
    this.latitude,
    this.longitude,
    this.businessStatus,
    this.tags,
    this.imageUrl,
    this.rating,
    this.userRatingsTotal,
    this.priceLevel,
    this.openNow,
  });

  final String placeId;
  final String? name;
  final bool? popular;
  final double? latitude;
  final double? longitude;
  final String? businessStatus;
  final List<String>? tags;
  final String? imageUrl;
  final double? rating;
  final int? userRatingsTotal;
  final int? priceLevel;
  final bool? openNow;
}

class DbResturantViewQueryable extends KeyedViewQueryable<DbResturantView, String> {
  @override
  String get keyName => 'place_id';

  @override
  String encodeKey(String key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "Resturant".*, "menu"."data" as "menu"'
      'FROM "Resturant"'
      'LEFT JOIN ('
      '  SELECT "Menu"."resturant_place_id",'
      '    to_jsonb(array_agg("Menu".*)) as data'
      '  FROM (${DbmenuViewQueryable().query}) "Menu"'
      '  GROUP BY "Menu"."resturant_place_id"'
      ') "menu"'
      'ON "Resturant"."place_id" = "menu"."resturant_place_id"';

  @override
  String get tableAlias => 'Resturant';

  @override
  DbResturantView decode(TypedMap map) => DbResturantView(
      placeId: map.get('place_id'),
      name: map.get('name'),
      popular: map.get('popular'),
      latitude: map.get('latitude'),
      longitude: map.get('longitude'),
      businessStatus: map.get('business_status'),
      menu: map.getListOpt('menu', DbmenuViewQueryable().decoder),
      tags: map.getListOpt('tags') ?? const [],
      imageUrl: map.get('image_url'),
      rating: map.get('rating'),
      userRatingsTotal: map.get('user_ratings_total'),
      priceLevel: map.get('price_level'),
      openNow: map.get('open_now'));
}

class DbResturantView {
  DbResturantView({
    required this.placeId,
    required this.name,
    required this.popular,
    required this.latitude,
    required this.longitude,
    required this.businessStatus,
    this.menu,
    required this.tags,
    required this.imageUrl,
    required this.rating,
    required this.userRatingsTotal,
    required this.priceLevel,
    required this.openNow,
  });

  final String placeId;
  final String name;
  final bool popular;
  final double latitude;
  final double longitude;
  final String businessStatus;
  final List<DbmenuView>? menu;
  final List<String> tags;
  final String imageUrl;
  final double rating;
  final int userRatingsTotal;
  final int priceLevel;
  final bool openNow;
}
