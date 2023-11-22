import 'package:alarm_app/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AlarmDetailsPage extends ConsumerWidget {
  const AlarmDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmChangeNotifier = ref.watch(alarmChangeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
                //*Need change
                // ref.read(alarmChangeNotifier.alarmList)
                //     .add(DateFormat('hh:mm a').format(ref.watch(alarmChangeNotifier.pickedTimeProvider)));
                alarmChangeNotifier.add(DateFormat('hh:mm a').format(ref.watch(alarmChangeNotifier.pickedTimeProvider)));
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check)),
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
                ref.read(alarmChangeNotifier.pickedTimeProvider.notifier).state = value;
              },
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            DateFormat('hh:mm a').format(ref.watch(alarmChangeNotifier.pickedTimeProvider)),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
