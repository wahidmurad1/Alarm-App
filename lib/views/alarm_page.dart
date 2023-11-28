import 'package:alarm_app/alarm_change_notifier.dart';
import 'package:alarm_app/sp_controller.dart';
import 'package:alarm_app/views/alarm_details_page.dart';
import 'package:alarm_app/consts/const.dart';

import 'package:alarm_app/providers.dart';
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
    final alarmRingNotifier = ref.watch(alarmRingNotifierProvider);
    // alarmRingNotifier.context = context;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              ref.read(alarmChangeNotifier.themeTypeProvider.notifier).state = !ref.read(alarmChangeNotifier.themeTypeProvider.notifier).state;
            },
            icon: ref.watch(alarmChangeNotifier.themeTypeProvider) == true
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
              ? Consumer(
                  builder: (context, ref, child) {
                    return IconButton(
                      onPressed: () {
                        ref.invalidate(alarmChangeNotifier.pickedTimeProvider);
                        ref.invalidate(alarmChangeNotifier.tempAlarmActionSelect);
                        ref.invalidate(alarmChangeNotifier.alarmActionSelect);
                        ref.invalidate(alarmChangeNotifier.vibrationSwitchProvider);
                        ref.invalidate(alarmChangeNotifier.ringtoneName);
                        // alarmChangeNotifier.ringtoneNameValue = '';
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlarmDetailsPage()));
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 28,
                        color: Colors.blue,
                      ),
                    );
                    // : const SizedBox();
                  },
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
                      // final switchState = ref.watch(alarmChangeNotifier.switchProvider(index));
                      return Slidable(
                        endActionPane: ActionPane(motion: const BehindMotion(), children: [
                          SlidableAction(
                              backgroundColor: cRedAccentColor,
                              icon: Icons.delete,
                              label: 'Delete',
                              onPressed: (context) {
                                SpController().deleteAlarm(index);
                                ref.read(alarmChangeNotifier.switchProvider(index).notifier).state = true;
                                if (index >= 0 && index < alarmChangeNotifier.alarmList.length) {
                                  alarmChangeNotifier.alarmList.removeAt(index);
                                  alarmChangeNotifier.updateState();
                                }
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Alarm deleted")));
                              }),
                          SlidableAction(backgroundColor: cBlueAccent, icon: Icons.close, label: 'Cancel', onPressed: (context) {}),
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
                                      alarmChangeNotifier.alarmList[index]['time'].toString(),
                                      style: semiBold24TextStyle(Theme.of(context).colorScheme.primary),
                                    ),
                                    Text(
                                      alarmChangeNotifier.alarmList[index]['repeat'].toString() == ''
                                          ? 'Ring once'
                                          : alarmChangeNotifier.alarmList[index]['repeat'].toString(),
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
                                        ref.read(alarmChangeNotifier.switchProvider(index).notifier).state = value;
                                        // alarmChangeNotifier.alarmList[index]['alarmSwitch'] = value;
                                        // if (ref.read(alarmChangeNotifier.switchProvider(index).notifier).state ||
                                        //     alarmChangeNotifier.alarmList[index]['alarmSwitch'] == false) {
                                        //   await Alarm.stop(index);
                                        // }

                                        // ref.read(setAlarmNotifier.switchProvider(index).notifier).state = v;

                                        //     if (!ref.read(setAlarmNotifier.switchProvider(index).notifier).state == true) {
                                        //       Alarm.stop(item[index]['id']);
                                        //       item[index]['isAlarmOn'] = false;
                                        //     } else {
                                        //       item[index]['isAlarmOn'] = true;
                                        //       final alarmSettings = AlarmSettings(
                                        //         id: item[index]['id'],
                                        //         dateTime: setAlarmNotifier.setAlarmTimeAgain(item[index]['dateTime']),
                                        //         assetAudioPath: 'assets/marimba.mp3',
                                        //         loopAudio: true,
                                        //         vibrate: item[index]['vibration'],
                                        //         volumeMax: true,
                                        //         fadeDuration: 3.0,
                                        //         notificationTitle: 'This is the title',
                                        //         notificationBody: 'This is the body',
                                        //         enableNotificationOnKill: true,
                                        //       );
                                        //       Alarm.set(alarmSettings: alarmSettings);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          ref.watch(alarmChangeNotifierProvider).alarmList.isEmpty
              ? SizedBox(
                  width: width - 40,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cPrimaryColor,
                        ),
                        onPressed: () {
                          ref.invalidate(alarmChangeNotifier.pickedTimeProvider);
                          ref.invalidate(alarmChangeNotifier.tempAlarmActionSelect);
                          ref.invalidate(alarmChangeNotifier.alarmActionSelect);
                          ref.invalidate(alarmChangeNotifier.vibrationSwitchProvider);
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlarmDetailsPage()));
                        },
                        child: Text(
                          'New Alarm',
                          style: semiBold16TextStyle(cWhiteColor),
                        )),
                  ))
              : const SizedBox(),
        ],
      ),
    );
  }
}
