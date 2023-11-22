import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlarmChangeNotifier extends ChangeNotifier {
  //   consumerState(){
  // }
  final List<String> alarmList = [];
  void add(String value) {
    alarmList.add(value);
    notifyListeners();
  }
  

  String getDifference(DateTime alarmTime) {
    if (alarmTime.isBefore(DateTime.now())) {
      Duration duration = Duration(hours: 24) + alarmTime.difference(DateTime.now());
      return '${duration.inHours.abs()} hours ${duration.inMinutes.remainder(60).abs()} Minutes';
    } else {
      Duration duration = DateTime.now().difference(alarmTime);
      return '${duration.inHours.abs()} hours ${duration.inMinutes.remainder(60).abs()} Minutes';
    }
  }

  final pickedTimeProvider = StateProvider<DateTime>(
    (ref) {
      return DateTime.now();
    },
  );
  // final currentTimeProvider = StateProvider<DateTime>(
  //   (ref) {
  //     return DateTime.now();
  //   },
  // );
  final switchProvider = StateProvider.family<bool, int>((ref, index) {
    return true;
  });
}
