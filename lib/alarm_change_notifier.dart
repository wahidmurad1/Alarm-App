import 'dart:convert';
import 'dart:developer';
import 'package:alarm/alarm.dart';
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
    // setAllAlarms();
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
  final alarmActionSelect = StateProvider<String>((ref) => '');
  final tempAlarmActionSelect = StateProvider<String>((ref) => '');
  final tempClockStyleState = StateProvider<String>((ref) => '12 Hours');
  final clockStyleState = StateProvider<String>((ref) => '12 Hours');
  String pickedTime = '';
  String repeatTypeValue = '';
  bool vibrationSwitchState = true;
  final ringtoneName = StateProvider<String>((ref) => '');
  String ringtoneNameValue = '';
  bool switchStateValue = true;
  String clockStyleValue = '12 Hours';
  DateTime selectedDateTime = DateTime.now();
  BuildContext? context;
  // bool themeType=true;
  final themeTypeProvider = StateProvider<bool>((ref) => true);

  void pickTime(time) {
    selectedDateTime = time;
    if (selectedDateTime.isBefore(DateTime.now())) {
      selectedDateTime = selectedDateTime.add(const Duration(days: 1));
    }
    if (clockStyleValue == '12 Hours') {
      pickedTime = DateFormat('h:mm a').format(time);
      log(clockStyleValue);
      log(pickedTime);
    } else {
      pickedTime = DateFormat('HH:mm').format(time);
    }
    notifyListeners();
  }

  // void pickTime(DateTime time) {
  //   selectedDateTime = time;
  //   if (selectedDateTime.isBefore(DateTime.now())) {
  //     selectedDateTime = selectedDateTime.add(const Duration(days: 1));
  //   }
  //   if (clockStyleValue == '12 Hours') {
  //     pickedTime = DateFormat('HH:mm a').format(time);
  //     print(clockStyleValue);
  //     print(pickedTime);
  //   } else {
  //     pickedTime = DateFormat('HH:mm').format(time);
  //   }
  //   notifyListeners();
  // }

  void saveAlarm(context) async {
    alarmList.clear();
    Map<String, dynamic> alarmDetails = {
      "time": pickedTime,
      "repeat": repeatTypeValue,
      "vibration": vibrationSwitchState,
      "ringtone": ringtoneNameValue,
      "alarmSwitch": switchStateValue
    };
    // alarmList.add(alarmDetails);
    String encodedMap = json.encode(alarmDetails);
    await SpController().saveAlarmDetails(encodedMap);
    await SpController().saveAlarmList(alarmDetails);
    alarmList = await SpController().getAlarmList();
    log(alarmList.toString());
    Navigator.pop(context);
    final alarmSettings = AlarmSettings(
      id: alarmList.length - 1,
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

  // Future<void> setAllAlarms() async {
  //   List<dynamic> alarmListDynamic = await SpController().getAlarmList();
  //   List<Map<String, dynamic>> alarmList = alarmListDynamic.cast<Map<String, dynamic>>();

  //   for (int i = 0; i < alarmList.length; i++) {
  //     Map<String, dynamic> alarmDetails = alarmList[i];
  //     DateTime alarmTime;
  //     if (clockStyleValue == '12 Hours') {
  //       DateFormat format = DateFormat("h:mm a");
  //       alarmTime = format.parse(alarmDetails['time']);
  //     } else {
  //       DateFormat format = DateFormat("HH:mm");
  //       alarmTime = format.parse(alarmDetails['time']);
  //     }

  //     // Ensure alarmTime is in the future
  //     DateTime now = DateTime.now();
  //     if (alarmTime.isBefore(now)) {
  //       alarmTime = alarmTime.add(Duration(days: 1));
  //     }

  //     switch (alarmDetails['repeat']) {
  //       case 'Once':
  //         // Set a single alarm
  //         final alarmSettings = AlarmSettings(
  //           id: i,
  //           dateTime: alarmTime,
  //           assetAudioPath: alarmDetails['ringtone'] == "" ? 'assets/alarm.mp3' : alarmDetails['ringtone'],
  //           loopAudio: true,
  //           vibrate: alarmDetails['vibration'],
  //           volumeMax: true,
  //           fadeDuration: 3.0,
  //           notificationTitle: 'Alarm',
  //           notificationBody: 'This is the Alarm',
  //           enableNotificationOnKill: false,
  //         );
  //         await Alarm.set(alarmSettings: alarmSettings);
  //         break;
  //       case 'Everyday':
  //         // Set an alarm for each day of the week
  //         for (int j = 0; j < 7; j++) {
  //           final alarmSettings = AlarmSettings(
  //             id: i * 10 + j, // Use a unique ID for each alarm
  //             dateTime: alarmTime.add(Duration(days: j)),
  //             assetAudioPath: alarmDetails['ringtone'] == "" ? 'assets/alarm.mp3' : alarmDetails['ringtone'],
  //             loopAudio: true,
  //             vibrate: alarmDetails['vibration'],
  //             volumeMax: true,
  //             fadeDuration: 3.0,
  //             notificationTitle: 'Alarm',
  //             notificationBody: 'This is the Alarm',
  //             enableNotificationOnKill: false,
  //           );
  //           await Alarm.set(alarmSettings: alarmSettings);
  //         }
  //         break;
  //       case 'Sunday-Thursday':
  //         // Set an alarm for each day from Saturday to Thursday
  //         for (int j = 0; j < 6; j++) {
  //           final alarmSettings = AlarmSettings(
  //             id: i * 10 + j, // Use a unique ID for each alarm
  //             dateTime: alarmTime.add(Duration(days: j)),
  //             assetAudioPath: alarmDetails['ringtone'] == "" ? 'assets/alarm.mp3' : alarmDetails['ringtone'],
  //             loopAudio: true,
  //             vibrate: alarmDetails['vibration'],
  //             volumeMax: true,
  //             fadeDuration: 3.0,
  //             notificationTitle: 'Alarm',
  //             notificationBody: 'This is the Alarm',
  //             enableNotificationOnKill: false,
  //           );
  //           await Alarm.set(alarmSettings: alarmSettings);
  //         }
  //         break;
  //       case 'Custom':
  //         // Handle custom repeat intervals separately
  //         break;
  //     }
  //   }
  // }

  //   for (int i = 0; i < alarmList.length; i++) {
  //     Map<String, dynamic> alarmDetails = alarmList[i];
  //     DateTime alarmTime;
  //     if (clockStyleValue == '12 Hours') {
  //       DateFormat format = DateFormat("h:mm a");
  //       alarmTime = format.parse(alarmDetails['time']);
  //     } else {
  //       DateFormat format = DateFormat("HH:mm");
  //       alarmTime = format.parse(alarmDetails['time']);
  //     }

  //     switch (alarmDetails['repeat']) {
  //       case 'Ring once':
  //         // Set a single alarm
  //         final alarmSettings = AlarmSettings(
  //           id: i,
  //           dateTime: alarmTime,
  //           assetAudioPath: alarmDetails['ringtone'] == "" ? 'assets/alarm.mp3' : alarmDetails['ringtone'],
  //           loopAudio: true,
  //           vibrate: alarmDetails['vibration'],
  //           volumeMax: true,
  //           fadeDuration: 3.0,
  //           notificationTitle: 'Alarm',
  //           notificationBody: 'This is the Alarm',
  //           enableNotificationOnKill: false,
  //         );
  //         await Alarm.set(alarmSettings: alarmSettings);
  //         break;
  //       case 'Everyday':
  //         // Set an alarm for each day of the week
  //         for (int j = 0; j < 7; j++) {
  //           final alarmSettings = AlarmSettings(
  //             id: i * 10 + j, // Use a unique ID for each alarm
  //             dateTime: alarmTime.add(Duration(days: j)),
  //             assetAudioPath: alarmDetails['ringtone'] == "" ? 'assets/alarm.mp3' : alarmDetails['ringtone'],
  //             loopAudio: true,
  //             vibrate: alarmDetails['vibration'],
  //             volumeMax: true,
  //             fadeDuration: 3.0,
  //             notificationTitle: 'Alarm',
  //             notificationBody: 'This is the Alarm',
  //             enableNotificationOnKill: false,
  //           );
  //           await Alarm.set(alarmSettings: alarmSettings);
  //         }
  //         break;
  //       case 'Sunday-Thursday':
  //         // Set an alarm for each day from Saturday to Thursday
  //         for (int j = 0; j < 6; j++) {
  //           final alarmSettings = AlarmSettings(
  //             id: i * 10 + j, // Use a unique ID for each alarm
  //             dateTime: alarmTime.add(Duration(days: j)),
  //             assetAudioPath: alarmDetails['ringtone'] == "" ? 'assets/alarm.mp3' : alarmDetails['ringtone'],
  //             loopAudio: true,
  //             vibrate: alarmDetails['vibration'],
  //             volumeMax: true,
  //             fadeDuration: 3.0,
  //             notificationTitle: 'Alarm',
  //             notificationBody: 'This is the Alarm',
  //             enableNotificationOnKill: false,
  //           );
  //           await Alarm.set(alarmSettings: alarmSettings);
  //         }
  //         break;
  //       case 'Custom':
  //         // Handle custom repeat intervals separately
  //         break;
  //     }
  //   }
  // }

//   Future<void> setAllAlarms() async {
//  List<Map<String, dynamic>> alarmList = await SpController().getAlarmList();

//  for (int i = 0; i < alarmList.length; i++) {
//    Map<String, dynamic> alarmDetails = alarmList[i];
//    DateTime alarmTime = DateTime.parse(alarmDetails['time']);

//    switch (alarmDetails['repeat']) {
//      case 'Once':
//        // Set a single alarm
//        final alarmSettings = AlarmSettings(
//          id: i,
//          dateTime: alarmTime,
//          assetAudioPath: alarmDetails['ringtone'] == "" ? 'assets/alarm.mp3' : alarmDetails['ringtone'],
//          loopAudio: true,
//          vibrate: alarmDetails['vibration'],
//          volumeMax: true,
//          fadeDuration: 3.0,
//          notificationTitle: 'Alarm',
//          notificationBody: 'This is the Alarm',
//          enableNotificationOnKill: false,
//        );
//        await Alarm.set(alarmSettings: alarmSettings);
//        break;
//      case 'Everyday':
//        // Set an alarm for each day of the week
//        for (int j = 0; j < 7; j++) {
//          final alarmSettings = AlarmSettings(
//            id: i * 10 + j, // Use a unique ID for each alarm
//            dateTime: alarmTime.add(Duration(days: j)),
//            assetAudioPath: alarmDetails['ringtone'] == "" ? 'assets/alarm.mp3' : alarmDetails['ringtone'],
//            loopAudio: true,
//            vibrate: alarmDetails['vibration'],
//            volumeMax: true,
//            fadeDuration: 3.0,
//            notificationTitle: 'Alarm',
//            notificationBody: 'This is the Alarm',
//            enableNotificationOnKill: false,
//          );
//          await Alarm.set(alarmSettings: alarmSettings);
//        }
//        break;
//      case 'Sat-Thursday':
//        // Set an alarm for each day from Saturday to Thursday
//        for (int j = 0; j < 6; j++) {
//          final alarmSettings = AlarmSettings(
//            id: i * 10 + j, // Use a unique ID for each alarm
//            dateTime: alarmTime.add(Duration(days: j)),
//            assetAudioPath: alarmDetails['ringtone'] == "" ? 'assets/alarm.mp3' : alarmDetails['ringtone'],
//            loopAudio: true,
//            vibrate: alarmDetails['vibration'],
//            volumeMax: true,
//            fadeDuration: 3.0,
//            notificationTitle: 'Alarm',
//            notificationBody: 'This is the Alarm',
//            enableNotificationOnKill: false,
//          );
//          await Alarm.set(alarmSettings: alarmSettings);
//        }
//        break;
//      case 'Custom':
//        // Handle custom repeat intervals separately
//        break;
//    }
//  }
// }

  void updateState() {
    notifyListeners();
  }
}
