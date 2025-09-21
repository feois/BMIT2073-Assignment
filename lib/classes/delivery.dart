
import 'package:assignment/classes/part.dart';
import 'package:assignment/database.dart';
import 'package:assignment/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delivery.g.dart';

@JsonEnum()
enum DeliveryPriority {
  @JsonValue("Unimportant")
  unimportant,
  @JsonValue("Normal")
  normal,
  @JsonValue("Important")
  important,
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
  String? deliveryProof;

  Part get part => Part.fromCache(partId);

  Delivery({
    required this.id,
    required this.partId,
    required this.quantity,
    required this.destination,
    required this.orderDate,
    required this.requiredDate,
    required this.priority,
  });

  void deliver(DateTime date, String proof) {
    status = DeliveryStatus.delivered;
    deliveredDate = date;
    deliveryProof = proof;
  }

  String get fullStatus => switch (status) {
    DeliveryStatus.delivered => "${status} on ${dateFormat.format(deliveredDate!)}",
    _ => status.toString(),
  };

  factory Delivery.fromCache(int id) => Database.deliveriesMap[id]!;
  factory Delivery.fromJson(Json json) => _$DeliveryFromJson(json);

  Json toJson() => _$DeliveryToJson(this);
}
