
import 'package:assignment/classes/delivery.dart';
import 'package:assignment/utils.dart';
import 'package:flutter/material.dart';

class ViewProof extends StatelessWidget {
  final Delivery delivery;
  
  const ViewProof({super.key, required this.delivery});
  
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Delivery Proof - ${delivery.id}')),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Image.network(delivery.deliveryProof!),
    ),
  );
}
