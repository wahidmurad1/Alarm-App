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
        // scrolledUnderElevation: 30,
        // flexibleSpace: const SizedBox(
        //   height: 45,
        // ),
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
            // const SizedBox(
            //   height: 40,
            // ),
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
            )
          ],
        ),
      ),
    );
  }
}
