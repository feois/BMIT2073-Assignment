import 'package:assignment/pages/add_delivery.dart';
import 'package:assignment/pages/view_schedule.dart';
import 'package:assignment/providers/time_provider.dart';
import 'package:assignment/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 32,
        children: <Widget>[
          Text(
            'Sure\nOn Time!',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: navigate(context, () => const ViewSchedule()),
            child: const Text("View schedule"),
          ),
          ElevatedButton(
            onPressed: navigate(context, () => const AddDelivery()),
            child: const Text("Add new delivery"),
          ),
          Consumer<TimeProvider>(builder: (_, timeProvider, _) => Text(timeFormat.format(timeProvider.time))),
        ],
      ),
    ),
  );
}
