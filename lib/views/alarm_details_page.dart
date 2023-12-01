import 'dart:developer';

import 'package:alarm_app/widgets/bottom_sheet.dart';
import 'package:alarm_app/consts/const.dart';
import 'package:alarm_app/widgets/custom_list_tile.dart';
import 'package:alarm_app/widgets/custom_radio_button.dart';
import 'package:alarm_app/notifiers/providers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AlarmDetailsPage extends ConsumerWidget {
  const AlarmDetailsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmChangeNotifier = ref.watch(alarmChangeNotifierProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          ref.watch(alarmChangeNotifier.isEdit) ? 'Edit Alarm' : 'Add Alarm',
          style: semiBold18TextStyle(Theme.of(context).colorScheme.primary),
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (ref.watch(alarmChangeNotifier.isEdit)) {
                  alarmChangeNotifier.editAlarm(alarmChangeNotifier.alarmId, context);
                } else {
                  alarmChangeNotifier.saveAlarm(context);
                }
              },
              icon: Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.primary,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              // InkWell(
              //   onTap: () {
              //     ref.read(alarmChangeNotifier.tempClockStyleState.notifier).state = ref.watch(alarmChangeNotifier.clockStyleState);
              //     commonBottomSheet(
              //         bottomSheetHeight: 150,
              //         context: context,
              //         content: const ClockStyleContent(),
              //         onPressCloseButton: () {
              //           Navigator.pop(context);
              //         },
              //         onPressRightButton: () {
              //           ref.read(alarmChangeNotifier.clockStyleState.notifier).state = ref.watch(alarmChangeNotifier.tempClockStyleState);
              //           alarmChangeNotifier.clockStyleValue = ref.watch(alarmChangeNotifier.clockStyleState);
              //           Navigator.pop(context);
              //         },
              //         rightText: 'Done',
              //         rightTextStyle: semiBold16TextStyle(cPrimaryColor),
              //         title: 'Clock Style',
              //         isRightButtonShow: true);
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              //     child: Row(
              //       children: [
              //         Text(
              //           'Clock Style',
              //           style: semiBold18TextStyle(Theme.of(context).colorScheme.primary),
              //         ),
              //         const Spacer(),
              //         Text(
              //           ref.watch(alarmChangeNotifier.clockStyleState),
              //           style: semiBold14TextStyle(Theme.of(context).colorScheme.primary),
              //         ),
              //         Icon(
              //           Icons.keyboard_arrow_right_outlined,
              //           size: 28,
              //           color: Theme.of(context).colorScheme.primary,
              //         )
              //       ],
              //     ),
              //   ),
              // ),

              Consumer(
                builder: (context, ref, child) {
                  final clockStyle = ref.watch(alarmChangeNotifier.clockStyleState);
                  return ToggleSwitch(
                    minWidth: 90.0,
                    initialLabelIndex: clockStyle == '12 Hours' ? 0 : 1,
                    cornerRadius: 20.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    // activeBgColor: clockStyle == '12 Hours' ? [Colors.blue] : [Colors.pink],
                    totalSwitches: 2,
                    labels: const ['12 Hours', '24 Hours'],
                    activeBgColors: const [
                      [Colors.blue],
                      [Colors.pink]
                    ],
                    onToggle: (index) {
                      if (index == 0) {
                        ref.read(alarmChangeNotifier.clockStyleState.notifier).state = '12 Hours';
                        alarmChangeNotifier.clockStyleValue = '12 Hours';
                      } else if (index == 1) {
                        ref.read(alarmChangeNotifier.clockStyleState.notifier).state = '24 Hours';
                        alarmChangeNotifier.clockStyleValue = '24 Hours';
                      }
                      print('switched to: $index');
                    },
                  );
                },
              ),

              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 180,
                child: CupertinoDatePicker(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  initialDateTime: ref.watch(alarmChangeNotifier.isEdit) ? alarmChangeNotifier.dateTimeValue : DateTime.now(),
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: ref.watch(alarmChangeNotifier.clockStyleState) == '12 Hours' ? false : true,
                  onDateTimeChanged: (value) {
                    ref.read(alarmChangeNotifier.pickedTimeProvider.notifier).state = value;
                    alarmChangeNotifier.dateTimeValue = value;
                    alarmChangeNotifier.pickTime(value);
                    // alarmChangeNotifier.formattedTime(value);
                    ref.read(alarmChangeNotifierProvider).getDifference(ref.read(alarmChangeNotifier.pickedTimeProvider.notifier).state);
                  },
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                '${alarmChangeNotifier.getDifference(ref.watch(alarmChangeNotifier.pickedTimeProvider))} remaining',
                style: semiBold20TextStyle(Theme.of(context).colorScheme.primary),
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
                  ref.read(alarmChangeNotifier.tempAlarmActionSelect.notifier).state = ref.watch(alarmChangeNotifier.alarmActionSelect);
                  ref.read(isBottomSheetRightButtonActive.notifier).state = true;
                  commonBottomSheet(
                    bottomSheetHeight: 240,
                    context: context,
                    onPressCloseButton: () {
                      Navigator.pop(context);
                    },
                    onPressRightButton: () {
                      ref.read(alarmChangeNotifier.alarmActionSelect.notifier).state = ref.watch(alarmChangeNotifier.tempAlarmActionSelect);
                      alarmChangeNotifier.repeatTypeValue = ref.watch(alarmChangeNotifier.alarmActionSelect);
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
                      Text(
                        'Repeat',
                        style: semiBold18TextStyle(Theme.of(context).colorScheme.primary),
                      ),
                      const Spacer(),
                      Text(
                        ref.watch(alarmChangeNotifier.alarmActionSelect),
                        style: semiBold14TextStyle(Theme.of(context).colorScheme.primary),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right_outlined,
                        size: 28,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Divider(
                  thickness: 0.5,
                  color: cLineColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Text(
                      'Vibration',
                      style: semiBold18TextStyle(Theme.of(context).colorScheme.primary),
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
                  color: cLineColor,
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
                      if (result == null) return;
                      //* Open Single file
                      final file = result.files.first;
                      ref.read(alarmChangeNotifier.ringtoneName.notifier).state = file.name;
                      ref.read(alarmChangeNotifier.ringtoneName.notifier).state = file.path.toString();
                      var ringtoneNames = file.path.toString().split('file_picker/');
                      alarmChangeNotifier.ringtoneNameValue = ringtoneNames.last;
                      ref.read(alarmChangeNotifier.ringtoneName.notifier).state = ringtoneNames.last;
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Ringtone',
                            style: semiBold18TextStyle(Theme.of(context).colorScheme.primary),
                          ),
                          // const SizedBox(
                          //   width: 80,
                          // ),
                          Expanded(
                            child: SizedBox(
                              width: 100,
                              child: Text(
                                ref.watch(alarmChangeNotifier.ringtoneName) == '' ? 'Default' : ref.watch(alarmChangeNotifier.ringtoneName).toString(),
                                style: semiBold14TextStyle(Theme.of(context).colorScheme.primary),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_outlined,
                            size: 28,
                            color: Theme.of(context).colorScheme.primary,
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
                  color: cLineColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Label',
                      style: semiBold18TextStyle(Theme.of(context).colorScheme.primary),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 100,
                        child: Text(
                          ref.watch(alarmChangeNotifier.ringtoneName) == '' ? 'Alarm' : ref.watch(alarmChangeNotifier.ringtoneName).toString(),
                          style: semiBold14TextStyle(Theme.of(context).colorScheme.primary),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right_outlined,
                      size: 28,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Divider(
                  thickness: 0.5,
                  color: cLineColor,
                ),
              ),
            ],
          ),
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
                        // if (ref.read(alarmChangeNotifier.tempAlarmActionSelect.notifier).state == '') {
                        //   ref.read(isBottomSheetRightButtonActive.notifier).state = false;
                        // } else {
                        //   ref.read(isBottomSheetRightButtonActive.notifier).state = true;
                        // }
                      },
                      isSelected: ref.watch(alarmChangeNotifier.tempAlarmActionSelect) == alarmChangeNotifier.repeatType[index],
                    );
                  },
                ),
                itemColor: ref.watch(alarmChangeNotifier.tempAlarmActionSelect) == alarmChangeNotifier.repeatType[index] ? cPrimaryTint3Color : cWhiteColor,
                onPressed: () {
                  ref.read(alarmChangeNotifier.tempAlarmActionSelect.notifier).state = alarmChangeNotifier.repeatType[index];
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
