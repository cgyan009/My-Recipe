
import 'dart:convert';

import '../models/cuisine_model.dart';

import 'base_api.dart';

class CuisineApi extends BaseApi {
  CuisineApi({queryParameters, path})
      : super(queryParameters: queryParameters, path: path);

  Future<List<Cuisine>> get cuisines async {
    var actualResponse = await response;
    if(actualResponse == null) {
      return null;
    }
    var map = json.decode(actualResponse.body);
    var list = map['cuisines'];
    List<Cuisine> cuisineList = [];
    for (var cuisineMap in list) {
      var subMap = cuisineMap['cuisine'];
      cuisineList.add(Cuisine.fromJson(subMap));
    }

    return cuisineList;
  }
}