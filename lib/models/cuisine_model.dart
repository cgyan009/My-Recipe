
import '../models/base_model.dart';

class Cuisine extends BaseModel {
  Cuisine(id, name) : super(id, name);

  factory Cuisine.fromJson(Map<String, dynamic> json) =>
      Cuisine(json['cuisine_id'] as int, json['cuisine_name'] as String);
}