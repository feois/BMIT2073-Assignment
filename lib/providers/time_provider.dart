
import 'dart:async';
import 'package:flutter/material.dart';

class TimeProvider extends ChangeNotifier {
  DateTime _time = DateTime.now();
  late final Timer _timer;

  TimeProvider() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _time = DateTime.now();
      notifyListeners();
    });
  }

  DateTime get time => _time;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
