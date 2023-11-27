import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm_app/alarm_change_notifier.dart';
import 'package:alarm_app/views/alarm_ring_screen.dart';
import 'package:flutter/material.dart';

// class AlarmRingNotifier extends ChangeNotifier {
//   late List<AlarmSettings> alarms;
//   static StreamSubscription<AlarmSettings>? subscription;
//   BuildContext ? context;
//   final AlarmChangeNotifier alarmChangeNotifier = AlarmChangeNotifier();
//   AlarmRingNotifier(context) {
//     loadAlarms();
//     subscription ??= Alarm.ringStream.stream.listen(
//       (alarmSettings) => navigateToRingScreen(context, alarmSettings),
//     );
//   }

//   Future<void> navigateToRingScreen(BuildContext context, AlarmSettings alarmSettings) async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => AlarmRingScreen(alarmSettings: alarmSettings)),
//     );
//     loadAlarms();
//     notifyListeners();
//   }

//   void loadAlarms() {
//     alarms = Alarm.getAlarms();
//     alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
//     notifyListeners();
//   }
// }
class AlarmRingNotifier extends ChangeNotifier {
  late List<AlarmSettings> alarms;
  static StreamSubscription<AlarmSettings>? subscription;
  final AlarmChangeNotifier alarmChangeNotifier = AlarmChangeNotifier();
  
  AlarmRingNotifier() {
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) {
        navigateToRingScreen(alarmSettings);
      },
    );
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    // Get the current context
    BuildContext? context = alarmChangeNotifier.context;
    if (context != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AlarmRingScreen(alarmSettings: alarmSettings)),
      );
      loadAlarms();
      notifyListeners();
    }
  }

  void loadAlarms() {
    alarms = Alarm.getAlarms();
    alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    notifyListeners();
  }
}
