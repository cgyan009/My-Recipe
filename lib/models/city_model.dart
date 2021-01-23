import '../models/base_model.dart';

class City extends BaseModel {
  City(int id, String name) : super(id, name);

  factory City.fromJson(Map<String, dynamic> json) =>
      City(json['id'] as int, json['name'] as String);
}
