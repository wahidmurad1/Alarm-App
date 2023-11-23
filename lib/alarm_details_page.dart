import 'package:alarm_app/bottom_sheet.dart';
import 'package:alarm_app/const.dart';
import 'package:alarm_app/custom_list_tile.dart';
import 'package:alarm_app/custom_radio_button.dart';
import 'package:alarm_app/notification_services.dart';
import 'package:alarm_app/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AlarmDetailsPage extends ConsumerWidget {
  AlarmDetailsPage({super.key});
  final NotificationServices notificationServices = NotificationServices();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmChangeNotifier = ref.watch(alarmChangeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
        title: const Text('Set Alarm'),
        actions: [
          IconButton(
              onPressed: () {
                alarmChangeNotifier.add(DateFormat('hh:mm a').format(ref.watch(alarmChangeNotifier.pickedTimeProvider)));
                notificationServices.sendNotification('Alarm App', 'Your Current Alarm');
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check)),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: CupertinoDatePicker(
                initialDateTime: DateTime.now(),
                mode: CupertinoDatePickerMode.time,
                onDateTimeChanged: (value) {
                  ref.read(alarmChangeNotifier.pickedTimeProvider.notifier).state = value;
                  ref.read(alarmChangeNotifierProvider).getDifference(ref.read(alarmChangeNotifier.pickedTimeProvider.notifier).state);
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              DateFormat('hh:mm a').format(ref.watch(alarmChangeNotifier.pickedTimeProvider)),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              '${alarmChangeNotifier.getDifference(ref.watch(alarmChangeNotifier.pickedTimeProvider))} remaining',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(
                thickness: 0.5,
              ),
            ),
            InkWell(
              //*off the splash effect
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {
                if (ref.read(alarmChangeNotifier.alarmActionSelect.notifier).state == '') {
                  ref.read(alarmChangeNotifier.tempAlarmActionSelect.notifier).state = '';
                  ref.read(isBottomSheetRightButtonActive.notifier).state = false;
                } else {
                  ref.read(alarmChangeNotifier.tempAlarmActionSelect.notifier).state = ref.watch(alarmChangeNotifier.alarmActionSelect);
                  ref.read(isBottomSheetRightButtonActive.notifier).state = true;
                }
                commonBottomSheet(
                  bottomSheetHeight: 240,
                  context: context,
                  onPressCloseButton: () {
                    Navigator.pop(context);
                  },
                  onPressRightButton: () {
                    ref.read(alarmChangeNotifier.alarmActionSelect.notifier).state = ref.watch(alarmChangeNotifier.tempAlarmActionSelect);
                    if (ref.watch(alarmChangeNotifier.alarmActionSelect) != 'Custom') {
                      Navigator.pop(context);
                    } else {
                      ref.read(alarmChangeNotifier.tempAlarmActionSelect.notifier).state = ref.watch(alarmChangeNotifier.alarmActionSelect);
                      commonBottomSheet(
                        context: context,
                        onPressCloseButton: () {
                          Navigator.pop(context);
                        },
                        onPressRightButton: () {},
                        content: const CustomAlarmShow(),
                        rightText: 'Done',
                        title: 'Custom Alarm',
                        rightTextStyle: semiBold16TextStyle(cPrimaryColor),
                        isRightButtonShow: true,
                      );
                    }
                  },
                  //*first common bottom sheet content
                  content: const AlarmActionContent(),
                  rightText: 'Done',
                  title: 'Alarm',
                  rightTextStyle: semiBold16TextStyle(cPrimaryColor),
                  isRightButtonShow: true,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  children: [
                    const Text(
                      'Repeat',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    ref.watch(alarmChangeNotifier.alarmActionSelect) != "" ? Text(ref.watch(alarmChangeNotifier.alarmActionSelect)) : const SizedBox(),
                    const Icon(
                      Icons.keyboard_arrow_right_outlined,
                      size: 28,
                    )
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(
                thickness: 0.5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Text(
                    'Vibration',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  Consumer(
                    builder: (context, ref, child) {
                      final vibrationSwitch = ref.watch(alarmChangeNotifier.vibrationSwitchProvider);
                      return SizedBox(
                        width: 50,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: CupertinoSwitch(
                            activeColor: Colors.blue,
                            trackColor: const Color.fromARGB(255, 220, 218, 218),
                            value: vibrationSwitch,
                            onChanged: (value) {
                              ref.read(alarmChangeNotifier.vibrationSwitchProvider.notifier).state = value;
                            },
                            // activeTrackColor: Colors.blue,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(
                thickness: 0.5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  const Text(
                    'Ringtone',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  ref.watch(alarmChangeNotifier.alarmActionSelect) != "" ? Text(ref.watch(alarmChangeNotifier.alarmActionSelect)) : const SizedBox(),
                  const Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 28,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlarmActionContent extends ConsumerWidget {
  const AlarmActionContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmChangeNotifier = ref.watch(alarmChangeNotifierProvider);
    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: alarmChangeNotifier.repeatType.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CustomListTile(
                title: alarmChangeNotifier.repeatType[index].toString(),
                titleTextStyle: semiBold16TextStyle(cBlackColor),
                trailing: Consumer(
                  builder: (context, ref, child) {
                    return CustomRadioButton(
                      onChanged: () {
                        ref.read(alarmChangeNotifier.tempAlarmActionSelect.notifier).state = alarmChangeNotifier.repeatType[index];
                        if (ref.read(alarmChangeNotifier.tempAlarmActionSelect.notifier).state == '') {
                          ref.read(isBottomSheetRightButtonActive.notifier).state = false;
                        } else {
                          ref.read(isBottomSheetRightButtonActive.notifier).state = true;
                        }
                      },
                      isSelected: ref.watch(alarmChangeNotifier.tempAlarmActionSelect) == alarmChangeNotifier.repeatType[index],
                    );
                  },
                ),
                itemColor: ref.watch(alarmChangeNotifier.tempAlarmActionSelect) == alarmChangeNotifier.repeatType[index] ? cPrimaryTint3Color : cWhiteColor,
                onPressed: () {
                  ref.read(alarmChangeNotifier.tempAlarmActionSelect.notifier).state = alarmChangeNotifier.repeatType[index];
                  if (ref.read(alarmChangeNotifier.tempAlarmActionSelect.notifier).state == '') {
                    ref.read(isBottomSheetRightButtonActive.notifier).state = false;
                  } else {
                    ref.read(isBottomSheetRightButtonActive.notifier).state = true;
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class CustomAlarmShow extends ConsumerWidget {
  const CustomAlarmShow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmChangeNotifier = ref.watch(alarmChangeNotifierProvider);
    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: alarmChangeNotifier.customDays.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CustomListTile(
                title: alarmChangeNotifier.customDays[index].toString(),
                titleTextStyle: semiBold16TextStyle(cBlackColor),
                trailing: Consumer(
                  builder: (context, ref, child) {
                    final alarmChangeNotifier = ref.watch(alarmChangeNotifierProvider);
                    final checkBoxState = ref.watch(alarmChangeNotifier.checkBoxProvider(index));
                    return Checkbox(
                        value: checkBoxState,
                        checkColor: cPrimaryColor,
                        onChanged: (value) {
                          // ref.read(alarmChangeNotifier.checkBoxProvider.notifier).state = value;
                          // ref.read(alarmChangeNotifier.checkBoxProvider);
                          ref.read(alarmChangeNotifier.checkBoxProvider(index).notifier).state = value!;
                        });
                  },
                ),
                itemColor: ref.watch(alarmChangeNotifier.tempAlarmActionSelect) == alarmChangeNotifier.customDays[index] ? cPrimaryTint3Color : cWhiteColor,
                onPressed: () {
                  // ref.read(alarmChangeNotifier.tempAlarmActionSelect.notifier).state = alarmChangeNotifier.customDays[index];
                  // if (ref.read(alarmChangeNotifier.tempAlarmActionSelect.notifier).state == '') {
                  //   ref.read(isBottomSheetRightButtonActive.notifier).state = false;
                  // } else {
                  //   ref.read(isBottomSheetRightButtonActive.notifier).state = true;
                  // }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
