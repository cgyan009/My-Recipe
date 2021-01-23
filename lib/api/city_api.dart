import 'dart:convert';

import 'base_api.dart';
import '../models/city_model.dart';

class CityApi extends BaseApi {
  CityApi({queryParameters, path})
      : super(queryParameters: queryParameters, path: path);

  Future<List<City>> get cities async {
    var actualResponse = await response;
    if (actualResponse == null) {
      return null;
    }
    var map = json.decode(actualResponse.body);
    var list = map['location_suggestions'];
    List<City> cityList = [];
    for (var cityMap in list) {
      cityList.add(City.fromJson(cityMap));
    }
    return cityList;
  }
}
