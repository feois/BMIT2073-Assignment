
import 'dart:io';

import 'package:assignment/classes/delivery.dart';
import 'package:assignment/database.dart';
import 'package:assignment/pages/view_proof.dart';
import 'package:assignment/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ViewDelivery extends StatefulWidget {
  final Delivery delivery;

  const ViewDelivery({super.key, required this.delivery});

  @override
  State<StatefulWidget> createState() => _ViewDeliveryState();
}

class _ViewDeliveryState extends State<ViewDelivery> {
  final _imagePicker = ImagePicker();
  bool _updating = false;

  Delivery get delivery => widget.delivery;

  String _status() => switch (delivery.status) {
    DeliveryStatus.delivered => "${delivery.status} on ${dateFormat.format(delivery.deliveredDate!)}",
    _ => delivery.status.toString(),
  };

  void _snack(String text) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  Future<void> _confirmDelivery() async {
    setState(() => _updating = true);

    final file = await _imagePicker.pickImage(source: ImageSource.camera);

    if (file == null) {
      _snack('Failed to get image, try again.');
      return;
    }

    final url = await Database.uploadImage('delivery/${delivery.id}${path.extension(file.path)}', File(file.path), overwrite: true);
    
    delivery.deliver(DateTime.now(), url);
    
    await Database.supabase.from(Database.deliveryTable).update(delivery.toJson()).eq('id', delivery.id);

    _snack('Status updated successfully');

    setState(() => _updating = false);
  }

  Widget _action() {
    if (_updating) {
      return const CircularProgressIndicator();
    }

    if (delivery.status == DeliveryStatus.delivered) {
      return ElevatedButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewProof(delivery: delivery))),
        child: const Text('View delivery proof'),
      );
    }

    return ElevatedButton(onPressed: _confirmDelivery, child: const Text('Confirm delivery'));
  }

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
            Text('Status: ${_status()}'),
            Center(child: _action()),
          ],
        ),
      ),
    ),
  );
}
