import 'dart:convert';
import 'package:alarm/alarm.dart';
import 'package:alarm_app/sp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class AlarmChangeNotifier extends ChangeNotifier {
  AlarmChangeNotifier() {
    onInit();
  }
  Future<void> onInit() async {
    alarmList = await SpController().getAlarmList();
    themeType = await SpController().loadThemeType();

    notifyListeners();
  }

  List<dynamic> alarmList = [];

  void add(String value) {
    alarmList.add(value);
    notifyListeners();
  }

  final List<String> repeatType = ['Ring once', 'Everyday', 'Sunday-Thusday', 'Custom'];
  final List<String> customDays = ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednusday', 'Thusday', 'Friday'];
  final List<String> clockStyle = ['12 Hours', '24 Hours'];

  String getDifference(DateTime alarmTime) {
    if (alarmTime.isBefore(DateTime.now())) {
      Duration duration = const Duration(hours: 24) + alarmTime.difference(DateTime.now());
      return '${duration.inHours.abs()} hours ${duration.inMinutes.remainder(60).abs()} Minutes';
    } else {
      Duration duration = DateTime.now().difference(alarmTime);
      return '${duration.inHours.abs()} hours ${duration.inMinutes.remainder(60).abs()} Minutes';
    }
  }

  final pickedTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());

  final switchProvider = StateProvider.family<bool, int>((ref, index) => true);
  final vibrationSwitchProvider = StateProvider<bool>((ref) => true);
  final checkBoxProvider = StateProvider.family<bool, int>((ref, index) => false);
  final customDaysActionProvider = StateProvider.family<String, int>((ref, index) => '');
  final tempClockStyleState = StateProvider<String>((ref) => '12 Hours');
  final clockStyleState = StateProvider<String>((ref) => '12 Hours');
  String pickedTime = '';
  final tempAlarmActionSelect = StateProvider<String>((ref) => 'Ring once');
  final alarmActionSelect = StateProvider<String>((ref) => 'Ring once');
  String repeatTypeValue = 'Ring once';
  bool vibrationSwitchState = true;
  final ringtoneName = StateProvider<String>((ref) => '');
  String ringtoneNameValue = '';
  bool switchStateValue = true;
  String clockStyleValue = '12 Hours';
  final isEdit = StateProvider<bool>((ref) => false);
  DateTime selectedDateTime = DateTime.now();
  DateTime dateTimeValue = DateTime.now();
  final themeTypeProvider = StateProvider<bool>((ref) => true);
  bool themeType = true;
  int alarmId = -1;

  void pickTime(time) {
    selectedDateTime = time;
    if (selectedDateTime.isBefore(DateTime.now())) {
      selectedDateTime = selectedDateTime.add(const Duration(days: 1));
    }
    if (clockStyleValue == '12 Hours') {
      pickedTime = DateFormat('h:mm a').format(time);
    } else {
      pickedTime = DateFormat('HH:mm').format(time);
    }
    notifyListeners();
  }

  void saveAlarm(context) async {
    alarmList.clear();
    var id = DateTime.now().millisecondsSinceEpoch % 10000;
    Map<String, dynamic> alarmDetails = {
      "id": id,
      "time": pickedTime,
      "dateTime": dateTimeValue.toString(),
      "repeat": repeatTypeValue,
      "vibration": vibrationSwitchState,
      "ringtone": ringtoneNameValue,
      "alarmSwitch": true,
      "clockStyle": clockStyleValue,
    };
    String encodedMap = json.encode(alarmDetails);
    await SpController().saveAlarmDetails(encodedMap);
    await SpController().saveAlarmList(alarmDetails);
    alarmList = await SpController().getAlarmList();
    Navigator.pop(context);
    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: selectedDateTime,
      assetAudioPath: ringtoneNameValue == "" ? 'assets/alarm.mp3' : ringtoneNameValue,
      loopAudio: true,
      vibrate: vibrationSwitchState,
      volumeMax: true,
      fadeDuration: 3.0,
      notificationTitle: 'Alarm',
      notificationBody: 'This is the Alarm',
      enableNotificationOnKill: false,
    );
    Alarm.set(alarmSettings: alarmSettings);
    notifyListeners();
  }

  void editAlarm(id, context) async {
    for (int i = 0; i < alarmList.length; i++) {
      if (alarmList[i]['id'] == id) {
        alarmList[i]['time'] = pickedTime;
        alarmList[i]['dateTime'] = dateTimeValue.toString();
        alarmList[i]['repeat'] = repeatTypeValue;
        alarmList[i]['vibration'] = vibrationSwitchState;
        alarmList[i]['ringtone'] = ringtoneNameValue == "" ? 'assets/alarm.mp3' : ringtoneNameValue;
        alarmList[i]['alarmSwitch'] = true;
        alarmList[i]['clockStyle'] = clockStyleValue;
        await SpController().deleteAllData();
        for (int i = 0; i < alarmList.length; i++) {
          await SpController().saveAlarmList(alarmList[i]);
        }
        // alarmList.clear();
        alarmList = await SpController().getAlarmList();
        Navigator.pop(context);
        final alarmSettings = AlarmSettings(
          id: alarmList[i]['id'],
          dateTime: selectedDateTime,
          assetAudioPath: ringtoneNameValue == '' ? 'assets/alarm.mp3' : ringtoneNameValue,
          loopAudio: true,
          vibrate: vibrationSwitchState,
          volumeMax: true,
          fadeDuration: 3.0,
          notificationTitle: 'Alarm',
          notificationBody: 'This is the Alarm',
          enableNotificationOnKill: false,
        );
        Alarm.set(alarmSettings: alarmSettings);
        notifyListeners();
      }
    }
  }

  DateTime setAlarmTimeAgain(prevTime) {
    selectedDateTime = DateTime.parse(prevTime);
    if (selectedDateTime.isBefore(DateTime.now())) {
      selectedDateTime = selectedDateTime.add(const Duration(days: 1));
    }
    notifyListeners();
    return selectedDateTime;
  }

  void updateState() {
    notifyListeners();
  }

  final StopWatchTimer stopWatchTimer = StopWatchTimer();
  final isHour = true;
  @override
  void dispose() {
    stopWatchTimer.dispose();
    super.dispose();
  }

  final isPlay = StateProvider<bool>((ref) => true);
}
