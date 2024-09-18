import 'package:api/src/data/models/postgress/postgress.dart';
import 'package:stormberry/stormberry.dart';

part 'db_resturant.schema.dart';

/// PostgreSQL DB Restaurant model
@Model(tableName: 'Resturant')
abstract class DbResturant {
  /// Primary place id key, identifier for DB restaurant model
  @PrimaryKey()
  String get placeId;

  String get name;

  String get businessStatus;

  List<DBMenu>? get menu;

  List<String> get tags;

  String get imageUrl;

  double get rating;

  int get userRatingsTotal;

  int get priceLevel;

  bool get openNow;

  bool get popular;

  double get latitude;

  double get longitude;
}
