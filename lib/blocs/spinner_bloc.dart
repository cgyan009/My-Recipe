import 'dart:async';

import '../api/city_api.dart';
import '../api/cuisine_api.dart';
import '../models/city_model.dart';
import '../models/cuisine_model.dart';

class SpinnerBloc {
  final _cityController = StreamController<List<City>>.broadcast();

  Stream get cityStream => _cityController.stream;
  final _cuisineController = StreamController<List<Cuisine>>.broadcast();

  Stream get cuisineStream => _cuisineController.stream;

  Future<void> fetchData(CityApi cityApi, CuisineApi cuisineApi) async {
    var cities = await cityApi.cities;
    _cityController.add(cities);
    var cuisines = await cuisineApi.cuisines;
    _cuisineController.add(cuisines);
  }

  void dispose() {
    _cityController.close();
    _cuisineController.close();
  }
}
