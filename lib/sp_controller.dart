import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

const kAlarmDetails = 'kAlarmDetails';
const kAlarmList = 'kAlarmList';
const kSwitchState = 'kSwitchState';

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

  // Future<void> setAlarmSwitchState(List<bool> switchStates) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   List<String> switchStatesString = switchStates.map((state) => state.toString()).toList();
  //   await preferences.setStringList(kAlarmList, switchStatesString);
  // }

  // Future<List<bool>> getAlarmSwitchState() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   List<String> switchStatesString = preferences.getStringList(kAlarmList) ?? [];
  //   List<bool> switchStates = switchStatesString.map((state) => state == 'true').toList();
  //   return switchStates;
  // }

  // Future<dynamic> getAlarmList() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String? data = preferences.getString(kAlarmList);
  //   List alarmList = (data == null) ? [] : json.decode(data);
  //   return alarmList;
  // }

  Future<void> deleteAllData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(kAlarmList);
  }
  Future<void> deleteAlarm(int index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? data = preferences.getString(kAlarmList);
    List alarmList = (data == null) ? [] : json.decode(data);

    if (index >= 0 && index < alarmList.length) {
      alarmList.removeAt(index);
      for (int i = 0; i < alarmList.length; i++) {
        if (i >= index) {
          alarmList[i]['id'] = i;
        }
      }

      // Encode the updated list and save it back to SharedPreferences
      String encodeData = json.encode(alarmList);
      await preferences.setString(kAlarmList, encodeData);
    } else {
      log('Index out of range');
    }
  }
 Future<void> updateAlarmList(int index, Map<String, dynamic> newAlarm) async {
 SharedPreferences preferences = await SharedPreferences.getInstance();
 List previousAlarms = await getAlarmList();
 previousAlarms[index] = json.encode(newAlarm);
 String encodeData = json.encode(previousAlarms);
 await preferences.setString(kAlarmList, encodeData);
}

Future<void> saveThemeType(bool value) async {
 final prefs = await SharedPreferences.getInstance();
 prefs.setBool('themeType', value);
}
Future<bool> loadThemeType() async {
 final prefs = await SharedPreferences.getInstance();
 return prefs.getBool('themeType') ?? true;
}


}
