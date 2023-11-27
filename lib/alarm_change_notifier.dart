import 'dart:convert';
import 'dart:developer';
import 'package:alarm/alarm.dart';
import 'package:alarm_app/consts/const.dart';
import 'package:alarm_app/sp_controller.dart';
import 'package:alarm_app/widgets/common_alert_dialog.dart';
import 'package:alarm_app/widgets/custom_elevated_button.dart';
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
  String pickedTime = '';
  String repeatTypeValue = '';
  bool vibrationSwitchState = true;
  final ringtoneName = StateProvider<String>((ref) => '');
  String ringtoneNameValue = '';
  bool switchStateValue = true;
  DateTime selectedDateTime = DateTime.now();
  BuildContext? context;
  void formattedTime(time) {
    pickedTime = DateFormat('hh:mm a').format(time);
    notifyListeners();
  }

  void pickTime(time) {
    selectedDateTime = time;
    if (selectedDateTime.isBefore(DateTime.now())) {
      selectedDateTime = selectedDateTime.add(const Duration(days: 1));
    }
    pickedTime = DateFormat('HH:mm a').format(time);
    notifyListeners();
  }

  void saveAlarm(context) async {
    alarmList.clear();
    // await SpController().deleteAllData();
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

  void deleteAlarmAlertDialog({required BuildContext context, required int index}) {
    showAlertDialog(
      context: context,
      child: CommonAlertDialog(
        hasCloseBtn: true,
        onClose: () => Navigator.pop(context),
        addContent: const Text('Are you sure you want to delete this alarm'),
        title: 'Confirmation',
        actions: [
          CustomElevatedButton(
            label: 'Delete',
            onPressed: () {
              SpController().deleteAlarm(index);
              // for (int i = 0; i < alarmList.length; i++) {
              //   alarmList.removeAt(index);
              //   notifyListeners();
              // }
              if (index >= 0 && index < alarmList.length) {
                // Remove the alarm at the specified index
                alarmList.removeAt(index);
                notifyListeners();
              }

              Navigator.pop(context);
            },
            buttonWidth: width * .45,
            buttonHeight: 40,
            buttonColor: cRedAccentColor,
          ),
          kH10sizedBox,
        ],
      ),
    );
  }
}
