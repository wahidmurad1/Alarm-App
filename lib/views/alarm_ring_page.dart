import 'package:alarm/alarm.dart';
import 'package:alarm_app/notifiers/providers.dart';
import 'package:alarm_app/sp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlarmRingScreen extends ConsumerWidget {
  final AlarmSettings? alarmSettings;

  const AlarmRingScreen({Key? key, this.alarmSettings}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmChangeNotifier = ref.watch(alarmChangeNotifierProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Wake up",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Text("🔔", style: TextStyle(fontSize: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RawMaterialButton(
                  onPressed: () {
                    final now = DateTime.now();
                    Alarm.set(
                      alarmSettings: alarmSettings!.copyWith(
                        dateTime: DateTime(
                          now.year,
                          now.month,
                          now.day,
                          now.hour,
                          now.minute,
                          0,
                          0,
                        ).add(const Duration(minutes: 5)),
                      ),
                    ).then((_) => Navigator.pop(context));
                  },
                  child: Text(
                    "Snooze",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () async {
                    for (int i = 0; i < alarmChangeNotifier.alarmList.length; i++) {
                      if (alarmChangeNotifier.alarmList[i]['id'] == alarmSettings!.id) {
                        if (alarmChangeNotifier.alarmList[i]['repeat'] == 'Ring once') {
                          Alarm.stop(alarmSettings!.id).then((_) => Navigator.pop(context));
                          alarmChangeNotifier.alarmList[i]['alarmSwitch'] = false;
                          alarmChangeNotifier.updateState();
                        } else if (alarmChangeNotifier.alarmList[i]['repeat'] == 'Everyday') {
                          Alarm.stop(alarmSettings!.id).then((_) => Navigator.pop(context));
                          alarmChangeNotifier.alarmList[i]['alarmSwitch'] = true;
                          DateTime selectedDateTime = DateTime.parse(alarmChangeNotifier.alarmList[i]['dateTime']);
                          selectedDateTime = selectedDateTime.add(const Duration(days: 1));
                          alarmChangeNotifier.alarmList[i]['dateTime'] = selectedDateTime.toString();
                          final newAlarmSettings = AlarmSettings(
                            id: alarmChangeNotifier.alarmList[i]['id'],
                            dateTime: selectedDateTime,
                            assetAudioPath: alarmChangeNotifier.alarmList[i]['ringtone'],
                            loopAudio: true,
                            vibrate: alarmChangeNotifier.alarmList[i]['vibration'],
                            volumeMax: true,
                            fadeDuration: 3.0,
                            notificationTitle: 'This is the title',
                            notificationBody: 'This is the body',
                            enableNotificationOnKill: true,
                          );
                          Alarm.set(alarmSettings: newAlarmSettings);
                          await SpController().deleteAllData();
                          for (int i = 0; i < alarmChangeNotifier.alarmList.length; i++) {
                            await SpController().saveAlarmList(alarmChangeNotifier.alarmList[i]);
                          }
                          alarmChangeNotifier.alarmList.clear();
                          alarmChangeNotifier.alarmList = await SpController().getAlarmList();
                        }
                        // else if(alarmChangeNotifier.alarmList[i]['repeat'] == 'Sunday-Thusday'){
                        //   Alarm.stop(alarmSettings!.id).then((_) => Navigator.pop(context));
                        //   // alarmChangeNotifier.alarmList[i]['alarmSwitch'] = true;
                        // }
                        else if (alarmChangeNotifier.alarmList[i]['repeat'] == 'Sunday-Thursday') {
                          DateTime now = DateTime.now();
                          if (now.weekday >= DateTime.sunday && now.weekday <= DateTime.thursday) {
                            Alarm.stop(alarmSettings!.id).then((_) => Navigator.pop(context));
                            alarmChangeNotifier.alarmList[i]['alarmSwitch'] = true;
                            DateTime selectedDateTime = DateTime.parse(alarmChangeNotifier.alarmList[i]['dateTime']);
                            selectedDateTime = selectedDateTime.add(const Duration(days: 1));
                            alarmChangeNotifier.alarmList[i]['dateTime'] = selectedDateTime.toString();
                            final newAlarmSettings = AlarmSettings(
                              id: alarmChangeNotifier.alarmList[i]['id'],
                              dateTime: selectedDateTime,
                              assetAudioPath: alarmChangeNotifier.alarmList[i]['ringtone'],
                              loopAudio: true,
                              vibrate: alarmChangeNotifier.alarmList[i]['vibration'],
                              volumeMax: true,
                              fadeDuration: 3.0,
                              notificationTitle: 'This is the title',
                              notificationBody: 'This is the body',
                              enableNotificationOnKill: true,
                            );
                            Alarm.set(alarmSettings: newAlarmSettings);
                            Alarm.set(alarmSettings: newAlarmSettings);
                            await SpController().deleteAllData();
                            for (int i = 0; i < alarmChangeNotifier.alarmList.length; i++) {
                              await SpController().saveAlarmList(alarmChangeNotifier.alarmList[i]);
                            }
                            alarmChangeNotifier.alarmList.clear();
                            alarmChangeNotifier.alarmList = await SpController().getAlarmList();
                          }
                        }
                      }
                    }
                  },
                  child: Text(
                    "Stop",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
