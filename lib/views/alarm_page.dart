import 'package:alarm/alarm.dart';
import 'package:alarm_app/alarm_change_notifier.dart';
import 'package:alarm_app/views/alarm_details_page.dart';
import 'package:alarm_app/consts/const.dart';

import 'package:alarm_app/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlarmPage extends ConsumerWidget {
  AlarmPage({super.key});
  final AlarmChangeNotifier alarmChange = AlarmChangeNotifier();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmChangeNotifier = ref.watch(alarmChangeNotifierProvider);
    final alarmRingNotifier = ref.watch(alarmRingNotifierProvider);
    // alarmRingNotifier.context = context;
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: cBackgroundColor,
          appBar: AppBar(
            backgroundColor: cBackgroundColor,
            elevation: 0,
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
                          style: semiBold16TextStyle(cWhiteColor),
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
                          return InkWell(
                            onLongPress: () {
                              alarmChangeNotifier.deleteAlarmAlertDialog(context: context, index: index);
                            },
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
                                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: cWhiteColor),
                                        ),
                                        Text(
                                          alarmChangeNotifier.alarmList[index]['repeat'].toString() == ''
                                              ? 'Ring once'
                                              : alarmChangeNotifier.alarmList[index]['repeat'].toString(),
                                          style: semiBold16TextStyle(cTextSecondaryColor),
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
                                          value: ref.watch(alarmChangeNotifier.switchProvider(index)),
                                          onChanged: (value) async {
                                            ref.read(alarmChangeNotifier.switchProvider(index).notifier).state = value;
                                            if (ref.read(alarmChangeNotifier.switchProvider(index).notifier).state == false) {
                                              await Alarm.stop(index);
                                            }
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
        ),
      ),
    );
  }
}
