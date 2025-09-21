
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final dateFormat = DateFormat('yyyy-MM-dd');
final timeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

void Function() navigate(BuildContext context, Widget Function() widget)
  => () => Navigator.push(context, MaterialPageRoute(builder: (_) => widget()));

void snack(State state, String text) {
  if (state.mounted) {
    ScaffoldMessenger.of(state.context).showSnackBar(SnackBar(content: Text(text)));
  }
}

String? validateInt(
  String text,
  bool Function(int) validator,
  {required String empty, required String nan, required String invalidated}
) {
  if (text.isEmpty) {
    return empty;
  }

  final i = int.tryParse(text);

  if (i == null) {
    return nan;
  }

  return validator(i) ? null : invalidated;
}

bool matchString(String str, String query) => str.toLowerCase().contains(query.toLowerCase());
