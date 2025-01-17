import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yandex_eats_clone/restutrants/resturants.dart';

class FilteredRestaurantsView extends StatelessWidget {
  const FilteredRestaurantsView({super.key});

  @override
  Widget build(BuildContext context) {
    final filteredRestaurants =
        context.select((ResturantsBloc bloc) => bloc.state.filteredResturants);

    return ResturantListView(resturants: filteredRestaurants);
  }
}
