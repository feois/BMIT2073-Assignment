
import 'package:assignment/database.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delivery.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum DeliveryPriority {
  normal,
  urgent,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum DeliveryStatus {
  pickedUp,
  enRoute,
  delivered,
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Delivery {
  final int id;
  int part;
  int quantity;
  String destination;
  DateTime orderDate;
  DateTime requiredDate;
  DeliveryPriority priority;
  DeliveryStatus status = DeliveryStatus.pickedUp;
  DateTime? deliveredDate;

  Delivery({
    required this.id,
    required this.part,
    required this.quantity,
    required this.destination,
    required this.orderDate,
    required this.requiredDate,
    required this.priority,
  });
  
  factory Delivery.fromJson(Json json) => _$DeliveryFromJson(json);

  Json toJson() => _$DeliveryToJson(this);
}
