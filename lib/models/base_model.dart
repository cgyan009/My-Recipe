class BaseModel {
  final int id;
  final String name;

  BaseModel(this.id, this.name);

  @override
  String toString() => 'id: $id, name: $name';

  factory BaseModel.fromJson(Map<String, dynamic> json) =>
      BaseModel(json['id'] as int, json['name'] as String);
}
