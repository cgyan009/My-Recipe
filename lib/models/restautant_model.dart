import 'base_model.dart';

class Restaurant extends BaseModel {
  final String url;

  Restaurant(id, name, this.url) : super(id, name);

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        int.parse(json['id']) ,
        json['name'] as String,
        json['url'] as String,
      );
}
