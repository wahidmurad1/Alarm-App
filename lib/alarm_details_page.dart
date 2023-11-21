import 'package:alarm_app/alarm_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';

class AlarmDetailsPage extends ConsumerWidget {
  const AlarmDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hour = ref.watch(hourProvider);
    final minute = ref.watch(minuteProvider);
    final timeFormat = ref.watch(timeFormatProvider);
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
                ref.read(alarmListProvider.notifier).add('${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${timeFormat.toString()}');
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NumberPicker(
                    minValue: 0,
                    maxValue: 12,
                    value: hour,
                    zeroPad: true,
                    infiniteLoop: true,
                    itemWidth: 80,
                    itemHeight: 60,
                    onChanged: (value) {
                      ref.read(hourProvider.notifier).state = value;
                    },
                    textStyle: const TextStyle(fontSize: 20, color: Colors.grey),
                    selectedTextStyle: const TextStyle(fontSize: 24, color: Colors.white),
                    decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white), bottom: BorderSide(color: Colors.white))),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  NumberPicker(
                    minValue: 0,
                    maxValue: 59,
                    value: minute,
                    zeroPad: true,
                    infiniteLoop: true,
                    itemWidth: 80,
                    itemHeight: 60,
                    onChanged: (value) {
                      ref.read(minuteProvider.notifier).state = value;
                    },
                    textStyle: const TextStyle(fontSize: 20, color: Colors.grey),
                    selectedTextStyle: const TextStyle(fontSize: 24, color: Colors.white),
                    decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white), bottom: BorderSide(color: Colors.white))),
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          ref.read(timeFormatProvider.notifier).state = 'AM';
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                              color: timeFormat == 'AM' ? Colors.grey.shade800 : Colors.grey.shade700,
                              border: Border.all(color: timeFormat == 'AM' ? Colors.grey : Colors.grey.shade700)),
                          child: const Text(
                            'AM',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      InkWell(
                        onTap: () {
                          ref.read(timeFormatProvider.notifier).state = 'PM';
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                              color: timeFormat == 'PM' ? Colors.grey.shade800 : Colors.grey.shade700,
                              border: Border.all(color: timeFormat == 'PM' ? Colors.grey : Colors.grey.shade700)),
                          child: const Text(
                            'PM',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Selected Time ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${timeFormat.toString()}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      print(pickedTime.format(context));
    }
  }
}
