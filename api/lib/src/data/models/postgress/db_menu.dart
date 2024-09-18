import 'package:api/src/data/models/postgress/postgress.dart';
import 'package:stormberry/stormberry.dart';

part 'db_menu.schema.dart';

@Model(tableName: 'Menu')
abstract class DBMenu {
  @PrimaryKey()
  @AutoIncrement()
  int get id;

  String get category;

  List<DBMenuItem> get items;
}
