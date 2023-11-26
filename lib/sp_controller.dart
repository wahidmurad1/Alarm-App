import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const kAlarmDetails = 'kAlarmDetails';
const kAlarmList = 'kAlarmList';

class SpController {
  Future<void> saveAlarmDetails(alarmDetails) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(kAlarmDetails, alarmDetails.toString());
  }

  Future<String?> getAlarmDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(kAlarmDetails);
  }

  Future<void> saveAlarmList(alarmList) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List previousAlarms = await getAlarmList();
    previousAlarms.add(alarmList);
    String encodeData = json.encode(previousAlarms);
    await preferences.setString(kAlarmList, encodeData);
  }

  Future<dynamic> getAlarmList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? data = preferences.getString(kAlarmList);
    List alarmList = (data == null) ? [] : json.decode(data);
    return alarmList;
  }

  Future<void> deleteAllData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(kAlarmList);
  }
}