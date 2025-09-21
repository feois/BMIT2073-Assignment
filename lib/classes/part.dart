
import 'package:assignment/database.dart';
import 'package:json_annotation/json_annotation.dart';

part 'part.g.dart';

@JsonSerializable()
class Part {
  final int id;
  String name;
  String description;
  double price;
  String image;

  Part({required this.id, required this.name, required this.description, required this.price, required this.image});

  factory Part.fromCache(int id) => Database.partsMap[id]!;
  factory Part.fromJson(Json json) => _$PartFromJson(json);

  Json toJson() => _$PartToJson(this);
}
