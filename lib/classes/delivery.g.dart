// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Delivery _$DeliveryFromJson(Map<String, dynamic> json) =>
    Delivery(
        id: (json['id'] as num).toInt(),
        part: (json['part'] as num).toInt(),
        quantity: (json['quantity'] as num).toInt(),
        destination: json['destination'] as String,
        orderDate: DateTime.parse(json['order_date'] as String),
        requiredDate: DateTime.parse(json['required_date'] as String),
        priority: $enumDecode(_$DeliveryPriorityEnumMap, json['priority']),
      )
      ..status = $enumDecode(_$DeliveryStatusEnumMap, json['status'])
      ..deliveredDate = json['delivered_date'] == null
          ? null
          : DateTime.parse(json['delivered_date'] as String);

Map<String, dynamic> _$DeliveryToJson(Delivery instance) => <String, dynamic>{
  'id': instance.id,
  'part': instance.part,
  'quantity': instance.quantity,
  'destination': instance.destination,
  'order_date': instance.orderDate.toIso8601String(),
  'required_date': instance.requiredDate.toIso8601String(),
  'priority': _$DeliveryPriorityEnumMap[instance.priority]!,
  'status': _$DeliveryStatusEnumMap[instance.status]!,
  'delivered_date': instance.deliveredDate?.toIso8601String(),
};

const _$DeliveryPriorityEnumMap = {
  DeliveryPriority.normal: 'normal',
  DeliveryPriority.urgent: 'urgent',
};

const _$DeliveryStatusEnumMap = {
  DeliveryStatus.pickedUp: 'picked_up',
  DeliveryStatus.enRoute: 'en_route',
  DeliveryStatus.delivered: 'delivered',
};
