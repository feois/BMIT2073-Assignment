
import 'package:assignment/classes/part.dart';
import 'package:assignment/database.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'delivery.g.dart';

@JsonEnum()
enum DeliveryPriority {
  @JsonValue("Normal")
  normal,
  @JsonValue("Urgent")
  urgent,
  ;

  @override
  String toString() => _$DeliveryPriorityEnumMap[this]!;
}

@JsonEnum()
enum DeliveryStatus {
  @JsonValue("Picked Up")
  pickedUp,
  @JsonValue("En Route")
  enRoute,
  @JsonValue("Delivered")
  delivered,
  ;

  @override
  String toString() => _$DeliveryStatusEnumMap[this]!;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Delivery {
  final int id;
  @JsonKey(name: "part")
  int partId;
  int quantity;
  String destination;
  DateTime orderDate;
  DateTime requiredDate;
  DeliveryPriority priority;
  DeliveryStatus status = DeliveryStatus.pickedUp;
  DateTime? deliveredDate;

  Part get part => Database.partsMap[partId]!;

  Delivery({
    required this.id,
    required this.partId,
    required this.quantity,
    required this.destination,
    required this.orderDate,
    required this.requiredDate,
    required this.priority,
  });
  
  factory Delivery.fromJson(Json json) => _$DeliveryFromJson(json);

  Json toJson() => _$DeliveryToJson(this);
}
