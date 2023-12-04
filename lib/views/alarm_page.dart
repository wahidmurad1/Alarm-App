import 'dart:developer';

import 'package:alarm/alarm.dart';
import 'package:alarm_app/notifiers/alarm_change_notifier.dart';
import 'package:alarm_app/sp_controller.dart';
import 'package:alarm_app/views/alarm_details_page.dart';
import 'package:alarm_app/consts/const.dart';
import 'package:alarm_app/notifiers/providers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AlarmPage extends ConsumerWidget {
  AlarmPage({super.key});
  final AlarmChangeNotifier alarmChange = AlarmChangeNotifier();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmChangeNotifier = ref.watch(alarmChangeNotifierProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            constraints: const BoxConstraints(),
            onPressed: () async {
              ref.read(alarmChangeNotifier.themeTypeProvider.notifier).state = !ref.read(alarmChangeNotifier.themeTypeProvider.notifier).state;
              alarmChangeNotifier.themeType = ref.watch(alarmChangeNotifier.themeTypeProvider);
              alarmChangeNotifier.updateState();
              await SpController().saveThemeType(ref.watch(alarmChangeNotifier.themeTypeProvider));
            },
            icon: alarmChangeNotifier.themeType == true
                ? const Icon(
                    CupertinoIcons.brightness,
                    color: cWhiteColor,
                  )
                : const Icon(
                    CupertinoIcons.moon_stars_fill,
                    color: cBlackColor,
                  )),
        title: const Text(
          'Alarm',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        actions: [
          ref.watch(alarmChangeNotifierProvider).alarmList.isNotEmpty
              ? AvatarGlow(
                  glowColor: Colors.blue,
                  endRadius: 30.0,
                  duration: const Duration(milliseconds: 3000),
                  repeat: true,
                  showTwoGlows: true,
                  repeatPauseDuration: const Duration(milliseconds: 100),
                  child: IconButton(
                    onPressed: () {
                      ref.invalidate(alarmChangeNotifier.pickedTimeProvider);
                      ref.invalidate(alarmChangeNotifier.tempAlarmActionSelect);
                      ref.invalidate(alarmChangeNotifier.alarmActionSelect);
                      ref.invalidate(alarmChangeNotifier.vibrationSwitchProvider);
                      ref.invalidate(alarmChangeNotifier.ringtoneName);
                      ref.read(alarmChangeNotifier.isEdit.notifier).state = false;
                      alarmChangeNotifier.repeatTypeValue = 'Ring once';
                      alarmChangeNotifier.customDays.clear();
                      alarmChangeNotifier.customDays.clear();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const AlarmDetailsPage()),
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 28,
                      color: Colors.blue,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
      body: Column(
        children: [
          ref.watch(alarmChangeNotifierProvider).alarmList.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      'No alarm',
                      style: semiBold16TextStyle(Theme.of(context).colorScheme.primary),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.separated(
                    itemCount: alarmChangeNotifier.alarmList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Divider(
                          color: cLineColor,
                          thickness: 0.5,
                        ),
                      );
                    },
                    itemBuilder: (context, index) {
                      var item = alarmChangeNotifier.alarmList[index];
                      return InkWell(
                        onTap: () async {
                          if (item['id'] == alarmChangeNotifier.alarmList[index]['id']) {
                            //*For Edit the data that already exists in alarmlist in shared preferences
                            ref.read(alarmChangeNotifier.isEdit.notifier).state = true;
                            alarmChangeNotifier.alarmId = item['id'];
                            ref.read(alarmChangeNotifier.alarmActionSelect.notifier).state = item['repeat'];
                            ref.read(alarmChangeNotifier.vibrationSwitchProvider.notifier).state = item['vibration'];
                            ref.read(alarmChangeNotifier.ringtoneName.notifier).state = item['ringtone'];
                            ref.read(alarmChangeNotifier.clockStyleState.notifier).state = item['clockStyle'];
                            alarmChangeNotifier.dateTimeValue = DateTime.parse(item['dateTime']);
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AlarmDetailsPage()));
                          }
                        },
                        child: Slidable(
                          endActionPane: ActionPane(extentRatio: 0.2, motion: const ScrollMotion(), children: [
                            SlidableAction(
                                backgroundColor: cRedAccentColor,
                                icon: Icons.delete,
                                label: 'Delete',
                                onPressed: (context) {
                                  Alarm.stop(item['id']);
                                  SpController().deleteAlarm(index);
                                  ref.read(alarmChangeNotifier.switchProvider(index).notifier).state = true;
                                  if (index >= 0 && index < alarmChangeNotifier.alarmList.length) {
                                    alarmChangeNotifier.alarmList.removeAt(index);
                                    alarmChangeNotifier.updateState();
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Alarm deleted")));
                                }),
                            // SlidableAction(backgroundColor: cBlueAccent, icon: Icons.close, label: 'Cancel', onPressed: (context) {}),
                          ]),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['time'].toString(),
                                        style: semiBold24TextStyle(Theme.of(context).colorScheme.primary),
                                      ),
                                      Text(
                                        item['repeat'].toString(),
                                        style: semiBold16TextStyle(Theme.of(context).colorScheme.secondary),
                                      ),
                                      Text(
                                        alarmChangeNotifier.getAlarmTimeRemaining(index: index),
                                        style: semiBold16TextStyle(Theme.of(context).colorScheme.secondary),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50,
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: CupertinoSwitch(
                                        activeColor: Colors.blue,
                                        trackColor: const Color.fromARGB(255, 220, 218, 218),
                                        value: alarmChangeNotifier.alarmList[index]['alarmSwitch'],
                                        onChanged: (value) async {
                                          DateTime now = DateTime.now();
                                          // log('in cupertino switch ${now.weekday >= DateTime.sunday}');
                                          // log('in cupertino switch ${now.weekday >= DateTime.sunday || now.weekday <= DateTime.thursday}');
                                          // int currentDayOfWeek = DateTime.now().weekday;
                                          // int daysUntilNextAlarm = 7;
                                          // for (int alarmDay in alarmChangeNotifier.customWeekDaysIndex) {
                                          //   int diff;
                                          //   if (alarmDay >= currentDayOfWeek) {
                                          //     diff = alarmDay - currentDayOfWeek;
                                          //     // log(diff.toString());
                                          //   } else {
                                          //     diff = alarmDay + 7 - currentDayOfWeek;
                                          //     // log(diff.toString());
                                          //   }
                                          //   if (diff < daysUntilNextAlarm) {
                                          //     daysUntilNextAlarm = diff;
                                          //     // log(daysUntilNextAlarm.toString());
                                          //   }
                                          // }
                                          // log(selectedCustomDays);
                                          // log(alarmChangeNotifier.customWeekDaysIndex.toString());
                                          // log(alarmChangeNotifier.customWeekDaysIndex.toString());
                                          // final selectedCustomDays = alarmChangeNotifier.alarmList[index]['repeat'];
                                          // // log('The days is : ${selectedCustomDays.weekday}'.toString());
                                          // // log(selectedCustomDays.weekday);
                                          // log(DateTime.monday.toString());
                                          // log('Current day index is : ${selectedCustomDays.weekday == DateTime.saturday}');
                                          // log((now.weekday == DateTime.tuesday).toString());
                                          // if (alarmChangeNotifier.alarmList[index]['repeat'] != 'Ring once' &&
                                          //     alarmChangeNotifier.alarmList[index]['repeat'] != 'Everyday' &&
                                          //     alarmChangeNotifier.alarmList[index]['repeat'] != 'Sunday-Thursday') {
                                          //   final selectedCustomDays = alarmChangeNotifier.alarmList[index]['repeat'];
                                          //   log('saturday ${selectedCustomDays.weekday == DateTime.saturday}');
                                          //   log('sun ${selectedCustomDays.weekday == DateTime.sunday}');
                                          //   log('mon ${selectedCustomDays.weekday == DateTime.monday}');
                                          //   log('tue ${selectedCustomDays.weekday == DateTime.tuesday}');
                                          //   log('wed ${selectedCustomDays.weekday == DateTime.wednesday}');
                                          //   log('thurs ${selectedCustomDays.weekday == DateTime.thursday}');
                                          //   log('fri ${selectedCustomDays.weekday == DateTime.friday}');
                                          // }
                                          log('${now.weekday == DateTime.sunday}');
                                          log(DateTime.sunday.toString());
                                          ref.read(alarmChangeNotifier.switchProvider(index).notifier).state = value;
                                          if (!ref.read(alarmChangeNotifier.switchProvider(index).notifier).state == true) {
                                            Alarm.stop(item['id']);
                                            item['alarmSwitch'] = false;
                                            alarmChangeNotifier.updateState();
                                          } else {
                                            item['alarmSwitch'] = true;
                                            alarmChangeNotifier.updateState();
                                            final alarmSettings = AlarmSettings(
                                              id: item['id'],
                                              dateTime: alarmChangeNotifier.setAlarmTimeAgain(item['dateTime']),
                                              assetAudioPath:
                                                  alarmChangeNotifier.ringtoneNameValue == "" ? 'assets/alarm.mp3' : alarmChangeNotifier.ringtoneNameValue,
                                              loopAudio: true,
                                              vibrate: item['vibration'],
                                              volumeMax: true,
                                              fadeDuration: 3.0,
                                              notificationTitle: 'Alarm',
                                              notificationBody: 'This is the body',
                                              enableNotificationOnKill: true,
                                            );
                                            Alarm.set(alarmSettings: alarmSettings);
                                          }
                                          await SpController().deleteAllData();
                                          for (int i = 0; i < alarmChangeNotifier.alarmList.length; i++) {
                                            await SpController().saveAlarmList(alarmChangeNotifier.alarmList[i]);
                                          }
                                          if (alarmChangeNotifier.alarmList[index]['repeat'] == 'Sunday-Thursday') {
                                            DateTime now = DateTime.now();
                                            log('${now.weekday >= DateTime.sunday}');
                                            log('${now.weekday <= DateTime.thursday}');
                                            if (now.weekday >= DateTime.sunday && now.weekday <= DateTime.thursday) {
                                              // Alarm.stop(alarmSettings!.id).then((_) => Navigator.pop(context));
                                              alarmChangeNotifier.alarmList[index]['alarmSwitch'] = true;
                                              DateTime selectedDateTime = DateTime.parse(alarmChangeNotifier.alarmList[index]['dateTime']);
                                              selectedDateTime = selectedDateTime.add(const Duration(days: 1));
                                              alarmChangeNotifier.alarmList[index]['dateTime'] = selectedDateTime.toString();
                                              final newAlarmSettings = AlarmSettings(
                                                id: alarmChangeNotifier.alarmList[index]['id'],
                                                dateTime: selectedDateTime,
                                                assetAudioPath: alarmChangeNotifier.alarmList[index]['ringtone'],
                                                loopAudio: true,
                                                vibrate: alarmChangeNotifier.alarmList[index]['vibration'],
                                                // volumeMax: true,
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
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          ref.watch(alarmChangeNotifierProvider).alarmList.isEmpty
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cPrimaryColor,
                  ),
                  onPressed: () {
                    ref.invalidate(alarmChangeNotifier.pickedTimeProvider);
                    ref.invalidate(alarmChangeNotifier.tempAlarmActionSelect);
                    ref.invalidate(alarmChangeNotifier.alarmActionSelect);
                    ref.invalidate(alarmChangeNotifier.vibrationSwitchProvider);
                    ref.invalidate(alarmChangeNotifier.ringtoneName);
                    ref.read(alarmChangeNotifier.isEdit.notifier).state = false;
                    alarmChangeNotifier.repeatTypeValue = 'Ring once';
                    alarmChangeNotifier.customDays.clear();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const AlarmDetailsPage()),
                    );
                  },
                  child: Text(
                    'Add Alarm',
                    style: semiBold16TextStyle(cWhiteColor),
                  ),
                )
              : const SizedBox(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
