import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:alarm_app/alarm_change_notifier.dart';
import 'package:alarm_app/consts/routes.dart';
import 'package:flutter/material.dart';

class AlarmRingNotifier extends ChangeNotifier {
  late List<AlarmSettings> alarms;
  static StreamSubscription<AlarmSettings>? subscription;
  final AlarmChangeNotifier alarmChangeNotifier = AlarmChangeNotifier();

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  AlarmRingNotifier() {
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await goRouter.push(krAlarmRing, extra: alarmSettings);
    loadAlarms();
    notifyListeners();
  }

  void loadAlarms() {
    alarms = Alarm.getAlarms();
    alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    notifyListeners();
  }
}

// class AlarmRingNotifier extends ChangeNotifier {
//  late List<AlarmSettings> alarms;
//  static StreamSubscription<AlarmSettings>? subscription;
//  final AlarmChangeNotifier alarmChangeNotifier = AlarmChangeNotifier();
//  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//  @override
//  void dispose() {
//    subscription?.cancel();
//    super.dispose();
//  }

//  AlarmRingNotifier() {
//    loadAlarms();
//    subscription ??= Alarm.ringStream.stream.listen(
//      (alarmSettings) {
//        navigateToRingScreen(alarmSettings);
//      },
//    );
//  }

//  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
//    navigatorKey.currentState!.push(
//      MaterialPageRoute(builder: (context) => AlarmRingScreen(alarmSettings: alarmSettings)),
//    );
//    loadAlarms();
//    notifyListeners();
//  }

//  void loadAlarms() {
//    alarms = Alarm.getAlarms();
//    alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
//    notifyListeners();
//  }
// }




  
