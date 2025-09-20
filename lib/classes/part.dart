
import 'package:assignment/database.dart';
import 'package:json_annotation/json_annotation.dart';

part 'part.g.dart';

@JsonSerializable()
class Part {
  final int id;
  String name;
  String description;
  double price;

  Part({required this.id, required this.name, required this.description, required this.price});

  factory Part.fromDb(Json object) => Part(
    id: object['id'] as int,
    name: object['name'] as String,
    description: object['description'] as String,
    price: object['price'] as double,
  );

  factory Part.fromJson(Json json) => _$PartFromJson(json);

  Json toJson() => _$PartToJson(this);
}
