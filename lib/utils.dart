
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final dateFormat = DateFormat('yyyy-MM-dd');
final timeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

Widget backButton(BuildContext context) => IconButton(
  icon: const Icon(Icons.arrow_back),
  onPressed: () => Navigator.pop(context),
);
