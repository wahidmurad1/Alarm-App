import 'package:alarm_app/alarm_change_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final alarmChangeNotifierProvider = ChangeNotifierProvider<AlarmChangeNotifier>((ref){
  return  AlarmChangeNotifier();
});
