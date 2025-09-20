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
            child: const Text("View schedule"),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewSchedule())),
          ),
          ElevatedButton(onPressed: () => {}, child: const Text("Add new delivery")),
          Consumer<TimeProvider>(builder: (_, timeProvider, _) => Text(timeFormat.format(timeProvider.time))),
        ],
      ),
    ),
  );
}
