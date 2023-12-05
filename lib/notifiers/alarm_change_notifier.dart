import 'dart:convert';
import 'dart:developer';
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
    log(alarmList.toString());
    notifyListeners();
  }

  List<dynamic> alarmList = [];

  void add(String value) {
    alarmList.add(value);
    notifyListeners();
  }

  final List<String> repeatType = ['Ring once', 'Everyday', 'Sunday-Thusday', 'Custom'];
  // final List<String> customDays = ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednusday', 'Thusday', 'Friday'];

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
  final themeTypeProvider = StateProvider<bool>((ref) => true);
  bool themeType = true;
  int alarmId = -1;
  String labelValue = 'Alarm';
  final hourProvider = StateProvider<int>((ref) => 0);
  final minuteProvider = StateProvider<int>((ref) => 0);
  final secondProvider = StateProvider<int>((ref) => 0);

  void pickTime(time) {
    selectedDateTime = time;
    if (selectedDateTime.isBefore(DateTime.now()) && repeatTypeValue == 'Custom') {
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
    if (repeatTypeValue == 'Custom') {
      int closingDay = 8;
      for (int i = 0; i < customDays.length; i++) {
        // if(selectedDayState[i]==true){
        //   customDays.add(days[i]);
        // }
        if (closingDay > getCustomDaysRemaining(customDays[i])) {
          closingDay = getCustomDaysRemaining(customDays[i]);
          log(closingDay.toString());
        }
        // updateState();
      }
      selectedDateTime = selectedDateTime.add(Duration(days: closingDay));
    }
    Map<String, dynamic> alarmDetails = {
      "id": id,
      "label": labelValue,
      "time": pickedTime,
      "dateTime": selectedDateTime.toString(),
      "repeat": repeatTypeValue != 'Custom' ? repeatTypeValue : customDays.join(', '),
      "dayIndex": repeatTypeValue != 'Custom' ? -1 : customWeekDaysIndex.join(', '),
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
    if (repeatTypeValue == 'Custom') {
      int closingDay = 8;
      for (int i = 0; i < customDays.length; i++) {
        // if(selectedDayState[i]==true){
        //   customDays.add(days[i]);
        // }
        if (closingDay > getCustomDaysRemaining(customDays[i])) {
          closingDay = getCustomDaysRemaining(customDays[i]);
          log(closingDay.toString());
        }
        // updateState();
      }
      selectedDateTime = selectedDateTime.add(Duration(days: closingDay));
    }
    for (int i = 0; i < alarmList.length; i++) {
      if (alarmList[i]['id'] == id) {
        alarmList[i]['label'] = labelValue;
        alarmList[i]['time'] = pickedTime;
        alarmList[i]['dateTime'] = selectedDateTime.toString();
        alarmList[i]['repeat'] = repeatTypeValue != 'Custom' ? repeatTypeValue : customDays.join(', ');
        alarmList[i]['dayIndex'] = repeatTypeValue != 'Custom' ? -1 : customWeekDaysIndex.join(', ');
        alarmList[i]['vibration'] = vibrationSwitchState;
        alarmList[i]['ringtone'] = ringtoneNameValue;
        alarmList[i]['alarmSwitch'] = true;
        alarmList[i]['clockStyle'] = clockStyleValue;
        await SpController().deleteAllData();
        for (int i = 0; i < alarmList.length; i++) {
          await SpController().saveAlarmList(alarmList[i]);
        }
        // alarmList.clear();
        alarmList = await SpController().getAlarmList();
        Navigator.pop(context);

        // alarmList[i]['dateTime'] = selectedDateTime.toString();
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
  final List<String> days = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  final List<bool> selectedDayState = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  final List<int> weekDaysIndex = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
  ];
  final List<int> weekSpecificIndex = [
    7,
    1,
    2,
    3,
    4,
  ];
  List<String> customDays = [];
  List<int> customWeekDaysIndex = [];

  final isDaySelected = StateProvider.family<bool, int>((ref, index) => false);
  final isRepeatSelected = StateProvider.family<bool, int>((ref, index) => true);
  String getAlarmTimeRemaining({required int index}) {
    Duration minDiff = const Duration(days: 365);
    if (alarmList[index]['alarmSwitch']) {
      DateTime dt1 = DateTime.parse(alarmList[index]['dateTime']);
      Duration diff = dt1.difference(DateTime.now());

      if (diff.inSeconds < 0) {
        diff = const Duration(hours: 23, minutes: 59) - diff.abs();
      }
      if (minDiff.inSeconds > diff.inSeconds) {
        minDiff = diff;
      }
    }

    int totalHours = minDiff.inHours;
    int totalMinutes = minDiff.inMinutes;
    int days = minDiff.inDays;
    int hours = totalHours.abs() % 24;
    int minutes = totalMinutes.abs() % 60;

    if (days.abs() == 1 && hours.abs() == 0 && minutes.abs() == 0) {
      hours = 24;
      minutes = 0;
      days = 0;
    }

    if (days.abs() == 0 && hours.abs() == 0 && minutes.abs() == 0) {
      return 'Alarm is ringing now';
    } else if (days.abs() == 0 && (hours.abs() != 0 || minutes.abs() != 0)) {
      return 'Next alarm in $hours hour $minutes minute';
    } else if (alarmList[index]['alarmSwitch'] == false) {
      return '';
    } else {
      return 'Next alarm in $days day $hours hour $minutes minute';
    }
  }

  DateTime calculateNextCustomDays(DateTime selectedDateTime, List<int> customWeekDaysIndex) {
    int currentDay = selectedDateTime.weekday;
    customWeekDaysIndex.sort();
    log('From Week days Sort List index ${customWeekDaysIndex.toString()}');

    for (int dayIndex in customWeekDaysIndex) {
      int daysToAdd = (dayIndex - currentDay + 7) % 7; // Calculate days to add, considering the circular nature of days
      log('In day Difference ${daysToAdd.toString()}');
      log('Next Alarm Schedule ${selectedDateTime.toString()}');
      log('Selected Day Index ${dayIndex.toString()}');
      log('Current Day Index ${currentDay.toString()}');

      if (daysToAdd > 0) {
        return selectedDateTime.add(Duration(days: daysToAdd));
      }
    }

    // If no suitable day is found in the current week, move to the next week
    int daysToAdd = (customWeekDaysIndex.first - currentDay + 7) % 7;
    // log('In day Difference ${daysToAdd.toString()}');
    // log('Next Alarm Schedule ${selectedDateTime.toString()}');
    // log('Selected Day Index ${customWeekDaysIndex.first.toString()}');
    // log('Current Day Index ${currentDay.toString()}');

    return selectedDateTime.add(Duration(days: daysToAdd));
  }

  DateTime calculateNextSundayToThursday(DateTime selectedDateTime) {
    int currentDay = selectedDateTime.weekday;
    if (currentDay >= 1 && currentDay <= 4) {
      int daysToAdd = 1;
      return selectedDateTime.add(Duration(days: daysToAdd));
    } else {
      int daysToAdd = (7 - currentDay) + 1;
      log(daysToAdd.toString());
      return selectedDateTime.add(Duration(days: daysToAdd));
    }
  }

  // int getCustomDaysRemaining(int customIndex) {
  //   DateTime now = DateTime.now();
  //   int currentDayIndex = now.weekday;
  //   dynamic targetDayIndex;
  //   // customIndex.sort();
  //   int remainingDay = -100;

  //   for (int i = 0; i < weekDaysIndex.length; i++) {
  //     for (int dayIndex in customIndex[i]) {
  //       if (weekDaysIndex[i] == dayIndex) {
  //         targetDayIndex = weekDaysIndex[i];
  //         log('1 ${targetDayIndex.toString()}');
  //       }
  //     }
  //   }

  //   if (targetDayIndex != null) {
  //     int remainingDay = targetDayIndex - currentDayIndex;
  //     if (remainingDay <= 0) {
  //       remainingDay = remainingDay + 7;
  //       log('2 ${targetDayIndex.toString()}');
  //     } else if (remainingDay == 0 && now.isBefore(selectedDateTime)) {
  //     } else if (remainingDay == 0 && now.isAfter(selectedDateTime)) {
  //       remainingDay = remainingDay + 7;
  //       log('3 ${targetDayIndex.toString()}');
  //     }
  //   }
  //   log('4 ${remainingDay.toString()}');
  //   return remainingDay;
  // }

  int getCustomDaysRemaining(String day) {
    DateTime now = DateTime.now();
    int currentDayIndex = now.weekday;
    dynamic targetDayIndex;
    if (day == 'Mon') {
      targetDayIndex = 1;
    } else if (day == 'Tue') {
      targetDayIndex = 2;
    } else if (day == 'Wed') {
      targetDayIndex = 3;
    } else if (day == 'Thu') {
      targetDayIndex = 4;
    } else if (day == 'Fri') {
      targetDayIndex = 5;
    } else if (day == 'Sat') {
      targetDayIndex = 6;
    } else {
      targetDayIndex = 7;
    }
    int remaingDay = targetDayIndex - currentDayIndex;
    if (remaingDay < 0) {
      remaingDay = remaingDay + 7;
    } else if (remaingDay == 0 && now.isBefore(selectedDateTime)) {
    } else if (remaingDay == 0 && now.isAfter(selectedDateTime)) {
      remaingDay = remaingDay + 7;
    }
    return remaingDay;
  }
}
