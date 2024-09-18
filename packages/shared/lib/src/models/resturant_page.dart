// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:api/client.dart';
import 'package:equatable/equatable.dart';

///{@template resturant_page}
///A representation of a resturant page
///{@endtemplate}
class ResturantPage extends Equatable {
  ///{@macro resturant_page}
  const ResturantPage({
    required this.resturants,
    required this.totalResturants,
    required this.page,
    required this.hasMore,
  });

  ///{@macro resturant_page.empty}
  ResturantPage.empty()
      : this(
          resturants: [],
          totalResturants: 0,
          page: 0,
          hasMore: false,
        );

  final int page;
  final List<Restaurant> resturants;
  final int totalResturants;
  final bool hasMore;

  @override
  List<Object?> get props => [resturants, totalResturants, page, hasMore];

  /// Copies the current[ResturantPage] instances and overrides the provides
  /// properties

  ResturantPage copyWith({
    int? page,
    List<Restaurant>? resturants,
    int? totalResturants,
    bool? hasMore,
  }) {
    return ResturantPage(
      page: page ?? this.page,
      resturants: resturants ?? this.resturants,
      totalResturants: totalResturants ?? this.totalResturants,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
