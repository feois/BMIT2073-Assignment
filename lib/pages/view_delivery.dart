
import 'package:assignment/classes/delivery.dart';
import 'package:assignment/database.dart';
import 'package:assignment/utils.dart';
import 'package:flutter/material.dart';

class ViewDelivery extends StatelessWidget {
  final Delivery delivery;

  ViewDelivery({super.key, required this.delivery});

  String _priority() => switch (delivery.priority) {
    DeliveryPriority.normal => "Normal",
    DeliveryPriority.urgent => "Urgent",
  };

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: backButton(context),
      title: Text('Delivery Information - ${delivery.id}'),
    ),
    body: Padding(
      padding: EdgeInsets.all(32),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyLarge!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Row(
              spacing: 32,
              children: [
                Image.network(
                  'https://sxnngstlymxxxlfyimno.supabase.co/storage/v1/object/public/images/cube.png',
                  width: 128,
                  height: 128,
                ),
                Text(delivery.part.name, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            Text(delivery.part.description),
            Text('Quantity: ${delivery.quantity}'),
            Text('Destination: ${delivery.destination}'),
            Text('Ordered On: ${dateFormat.format(delivery.orderDate)}'),
            Text('Required by: ${dateFormat.format(delivery.requiredDate)}'),
            Text('Priority: ${delivery.priority}'),
            Text('Status: ${delivery.status}'),
          ],
        ),
      ),
    ),
  );
}
