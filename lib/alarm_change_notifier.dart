import 'dart:convert';
import 'dart:developer';
import 'package:alarm_app/sp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AlarmChangeNotifier extends ChangeNotifier {
  AlarmChangeNotifier() {
    onInit();
  }
  Future<void> onInit() async {
    alarmList = await SpController().getAlarmList();
    notifyListeners();
  }

  List<dynamic> alarmList = [];

  void add(String value) {
    alarmList.add(value);
    notifyListeners();
  }

  final List<String> repeatType = ['Ring once', 'Everyday', 'Sunday-Thusday', 'Custom'];
  final List<String> customDays = ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednusday', 'Thusday', 'Friday'];

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
  final alarmActionSelect = StateProvider<String>((ref) => '');
  final tempAlarmActionSelect = StateProvider<String>((ref) => '');
  final fileName = StateProvider<String>((ref) => '');
  String pickedTime = '';
  String repeatTypeValue = '';
  bool vibrationSwitchState = true;
  String fileNameValue = '';
  bool switchStateValue = true;
  void formattedTime(time) {
    pickedTime = DateFormat('hh:mm a').format(time);
    notifyListeners();
  }

  void saveAlarm(context) async {
    alarmList.clear();
    // await SpController().deleteAllData();
    Map<String, dynamic> alarmDetails = {
      "time": pickedTime,
      "repeat": repeatTypeValue,
      "vibration": vibrationSwitchState,
      "ringtone": fileNameValue,
      "alarmSwitch": switchProvider
    };
    // alarmList.add(alarmDetails);
    String encodedMap = json.encode(alarmDetails);
    await SpController().saveAlarmDetails(encodedMap);
    await SpController().saveAlarmList(alarmDetails);
    alarmList = await SpController().getAlarmList();
    log(alarmList.toString());
    notifyListeners();
    Navigator.pop(context);
  }
}
