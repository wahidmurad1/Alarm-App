import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlarmChangeNotifier extends ChangeNotifier {
  final List<String> alarmList = [];
  void add(String value) {
    alarmList.add(value);
    notifyListeners();
  }

  final pickedTimeProvider = StateProvider<DateTime>(
    (ref) {
      return DateTime.now();
    },
  );
  final switchProvider = StateProvider.family<bool, int>((ref, index) {
    return true;
  });
}