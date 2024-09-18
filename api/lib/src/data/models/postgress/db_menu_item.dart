import 'package:stormberry/stormberry.dart';

part 'db_menu_item.schema.dart';

@Model(tableName: 'MenuItem')
abstract class DBMenuItem {
  @PrimaryKey()
  @AutoIncrement()
  int get id;

  String get name;

  String get description;

  String get imageUrl;

  double get price;

  double get discount;
}
