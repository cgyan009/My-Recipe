import 'dart:convert';

import '../models/restautant_model.dart';

import 'base_api.dart';

class RestaurantApi extends BaseApi {
  RestaurantApi({queryParameters, path})
      : super(queryParameters: queryParameters, path: path);

  Future<List<Restaurant>> get restaurants async {
    List<Restaurant> restaurantList = [];
    var actualResponse = await response;
    if (actualResponse == null) {
      return null;
    }
    var map = json.decode(actualResponse.body);
    List<dynamic> list = map['restaurants'];
    list.forEach((item) {
      var map = item as Map<String, dynamic>;
      var restaurantMap = map['restaurant'];
      restaurantList.add(Restaurant.fromJson(restaurantMap));
    });

    return restaurantList;
  }
}
