import 'package:alarm_app/alarm_change_notifier.dart';
import 'package:alarm_app/notifiers/alarm_ring_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final AlarmChangeNotifier alarmChangeNotifier = AlarmChangeNotifier();
final alarmChangeNotifierProvider = ChangeNotifierProvider<AlarmChangeNotifier>((ref) {
  return AlarmChangeNotifier();
});
final alarmRingNotifierProvider = ChangeNotifierProvider<AlarmRingNotifier>((ref) {
  return AlarmRingNotifier();
});
