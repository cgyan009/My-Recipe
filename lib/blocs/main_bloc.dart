import 'dart:async';

import '../api/city_api.dart';
import '../api/cuisine_api.dart';
import '../api/restaurant_api.dart';
import '../blocs/spinner_bloc.dart';
import '../models/base_model.dart';
import '../models/restautant_model.dart';

mixin MainBloc {
  SpinnerBloc spinnerBloc = SpinnerBloc();
  final spinnerInfo = <String, bool>{
    'city': false,
    'cuisine': false,
    'price': false,
  };
  final prices = <BaseModel>[
    BaseModel(1, '\$'),
    BaseModel(2, '\$\$'),
    BaseModel(3, '\$\$\$'),
    BaseModel(4, '\$\$\$\$'),
    BaseModel(5, '\$\$\$\$\$'),
  ];

  //city, cuisine data selected from ui
  final selectedInfo = <String, BaseModel>{};
  StreamController<Map<String, bool>> spinnerController =
      StreamController.broadcast();

  Stream get spinnerStream => spinnerController.stream;

  void clickLocker(int index, bool isLocked) {
    final names = ['city', 'cuisine', 'price'];
    final map = {names[index]: isLocked};
    spinnerInfo.addAll(map);
  }

  void loopSpinner(bool direction) {
    final map = {'direction': direction};
    spinnerInfo.addAll(map);
    spinnerController.add(spinnerInfo);
  }

  void loadData(double lat, double lon) {
    final cityParameters = {'lat': '$lat', 'lon': '$lon', 'count': '20'};
    final cityApi = CityApi(path: 'cities', queryParameters: cityParameters);
    final cuisineParameters = {'lat': '$lat', 'lon': '$lon'};
    final cuisineApi = CuisineApi(
      path: 'cuisines',
      queryParameters: cuisineParameters,
    );
    spinnerBloc.fetchData(cityApi, cuisineApi);
  }

  void handleEnteredLocation(String value) {
    final trimmedTxt = value.trim();
    if (trimmedTxt.isNotEmpty) {
      final list = value.split(',');
      final latStr = list[0];
      final lonStr = list[1];
      try {
        final lat = double.parse(latStr);
        final lon = double.parse(lonStr);
        loadData(lat, lon);
      } on FormatException catch (e) {
        print(e);
      }
    }
  }

  Future<List<Restaurant>> get searchedRestaurants async {
    int cityId = selectedInfo['city'].id;
    int cuisineId = selectedInfo['cuisine'].id;
    final tmpRestaurants = await RestaurantApi(queryParameters: {
      'entity_id': '$cityId',
      'cuisines': '$cuisineId',
      'count': '20',
    }, path: 'search')
        .restaurants;
    return tmpRestaurants;
  }
}
