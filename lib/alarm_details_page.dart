import 'package:alarm_app/alarm_list_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AlarmDetailsPage extends ConsumerWidget {
  const AlarmDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
        title: const Text('Set Alarm'),
        actions: [
          IconButton(
              onPressed: () {
                ref.read(alarmListProvider.notifier).add(DateFormat('hh:mm a').format(ref.watch(pickedTimeProvider)));
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 180,
            child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              mode: CupertinoDatePickerMode.time,
              onDateTimeChanged: (value) {
                ref.read(pickedTimeProvider.notifier).state = value;
              },
            ),
          ),
          // SizedBox(
          //   height: 180,
          //   child: Theme(
          //     data: ThemeData.light().copyWith(
          //       cupertinoOverrideTheme: CupertinoThemeData(
          //         textTheme: CupertinoTextThemeData(
          //           dateTimePickerTextStyle: TextStyle(
          //             color: Colors.red, // change this to your desired color
          //           ),
          //         ),
          //       ),
          //     ),
          //     child: CupertinoDatePicker(
          //       initialDateTime: DateTime.now(),
          //       mode: CupertinoDatePickerMode.time,
          //       onDateTimeChanged: (value) {
          //         ref.read(pickedTimeProvider.notifier).state = value;
          //       },
          //     ),
          //   ),
          // ),

          // CupertinoDatePicker(
          //     initialDateTime: DateTime.now(),
          //     mode: CupertinoDatePickerMode.time,
          //     onDateTimeChanged: (value) {
          //       ref.read(pickedTimeProvider.notifier).state = value;
          //     })),
          // Text(
          //   'Selected Time ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${timeFormat.toString()}',
          //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // ),
          const SizedBox(
            height: 40,
          ),
          Text(
            DateFormat('hh:mm a').format(ref.watch(pickedTimeProvider)),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
