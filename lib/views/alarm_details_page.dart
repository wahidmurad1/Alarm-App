import 'package:alarm_app/widgets/bottom_sheet.dart';
import 'package:alarm_app/consts/const.dart';
import 'package:alarm_app/widgets/custom_list_tile.dart';
import 'package:alarm_app/widgets/custom_radio_button.dart';
import 'package:alarm_app/providers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AlarmDetailsPage extends ConsumerWidget {
  AlarmDetailsPage({
    super.key,
  });
  // final NotificationServices notificationServices = NotificationServices();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   final alarmChangeNotifier = ref.watch(alarmChangeNotifierProvider);
    alarmChangeNotifier.pickedTime = DateFormat('hh:mm a').format(ref.watch(alarmChangeNotifier.pickedTimeProvider));
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
        title: const Text(
          'Set Alarm',
          style: TextStyle(color: cBlackColor),
        ),
        actions: [
          IconButton(
              onPressed: () {
                alarmChangeNotifier.add(DateFormat('hh:mm a').format(ref.watch(alarmChangeNotifier.pickedTimeProvider)));
                alarmChangeNotifier.saveAlarm(context);
                // SpController().deleteAllData();
                // SpController().getAlarmList();
              },
              icon: const Icon(
                Icons.check,
                color: cBlackColor,
              )),
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
                // itemExtent: 0,
                backgroundColor: cWhiteColor,
                initialDateTime: DateTime.now(),
                mode: CupertinoDatePickerMode.time,
                onDateTimeChanged: (value) {
                  ref.read(alarmChangeNotifier.pickedTimeProvider.notifier).state = value;
                  alarmChangeNotifier.formattedTime(value);
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
                    alarmChangeNotifier.repeatTypeValue = ref.watch(alarmChangeNotifier.alarmActionSelect);
                    // log(alarmChangeNotifier.repeatTypeValue);
                    if (ref.watch(alarmChangeNotifier.alarmActionSelect) != 'Custom') {
                      Navigator.pop(context);
                    } else {
                      // ref.read(alarmChangeNotifier.tempAlarmActionSelect.notifier).state = ref.watch(alarmChangeNotifier.alarmActionSelect);
                      Navigator.pop(context);
                      commonBottomSheet(
                        context: context,
                        onPressCloseButton: () {
                          Navigator.pop(context);
                        },
                        onPressRightButton: () {
                          Navigator.pop(context);
                        },
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
                              alarmChangeNotifier.vibrationSwitchState = value;
                            },
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
            Consumer(
              builder: (context, ref, child) {
                final alarmChangeNotifier = ref.watch(alarmChangeNotifierProvider);
                return InkWell(
                  highlightColor: cTransparentColor,
                  splashFactory: NoSplash.splashFactory,
                  onTap: () async {
                    final result = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.audio,
                    );
                    // allowMultiple: false;
                    if (result == null) return;
                    //* Open Single file
                    final file = result.files.first;
                    // print(file.name);
                    // .watch(alarmChangeNotifier) = file.name;
                    // ref.read(alarmChangeNotifier.fileName) = file.name;
                    ref.read(alarmChangeNotifier.fileName.notifier).state = file.name;
                    alarmChangeNotifier.fileNameValue = file.name;
                    // log(alarmChangeNotifier.fileNameValue);
                    //  openFile(file);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Row(
                      children: [
                        const Text(
                          'Ringtone',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Text(ref.watch(alarmChangeNotifier.fileName) == '' ? 'Default' : ref.watch(alarmChangeNotifier.fileName)),
                        const Icon(
                          Icons.keyboard_arrow_right_outlined,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(
                thickness: 0.5,
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
              child: Consumer(
                builder: (context, ref, child) {
                  final alarmChangeNotifier = ref.watch(alarmChangeNotifierProvider);
                  final checkBoxState = ref.watch(alarmChangeNotifier.checkBoxProvider(index));
                  return CustomListTile(
                    title: alarmChangeNotifier.customDays[index].toString(),
                    titleTextStyle: semiBold16TextStyle(cBlackColor),
                    trailing: Consumer(
                      builder: (context, ref, child) {
                        return Checkbox(
                            value: checkBoxState,
                            checkColor: cWhiteColor,
                            activeColor: cPrimaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            onChanged: (value) {
                              ref.read(alarmChangeNotifier.checkBoxProvider(index).notifier).state = value!;
                            });
                      },
                    ),
                    itemColor: checkBoxState ? cPrimaryTint3Color : cWhiteColor,
                    onPressed: () {
                      ref.read(alarmChangeNotifier.checkBoxProvider(index).notifier).state =
                          !ref.read(alarmChangeNotifier.checkBoxProvider(index).notifier).state;
                      // ref.read(alarmChangeNotifier.tempAlarmActionSelect.notifier).state = alarmChangeNotifier.customDays[index];
                      // if (ref.read(alarmChangeNotifier.tempAlarmActionSelect.notifier).state == '') {
                      //   ref.read(isBottomSheetRightButtonActive.notifier).state = false;
                      // } else {
                      //   ref.read(isBottomSheetRightButtonActive.notifier).state = true;
                      // }
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
