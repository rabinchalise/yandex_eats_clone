enum AppRoutes {
  splash('/spalsh'),
  auth('/auth'),
  resturants('/restaurants'),
  orders('/orders'),
  order('/order'),
  profile('/profiles'),
  updateEmail('/update-email'),
  googleMap('/googleMap'),
  search('/search'),
  searchLocation('/search-Location'),
  menu('/menu'),
  cart('/cart');

  const AppRoutes(this.route);

  final String route;
}
