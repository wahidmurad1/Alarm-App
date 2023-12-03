import 'package:alarm_app/notifiers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';

class TimerPage extends ConsumerWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmChangeNotifier = ref.watch(alarmChangeNotifierProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Timer'),
        centerTitle: true,
      ),
      body: Column(
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
                  maxValue: 23,
                  value: ref.watch(alarmChangeNotifier.hourProvider),
                  zeroPad: true,
                  infiniteLoop: true,
                  itemWidth: 80,
                  itemHeight: 60,
                  onChanged: (value) {
                    ref.read(alarmChangeNotifier.hourProvider.notifier).state = value;
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
                  value: ref.watch(alarmChangeNotifier.minuteProvider),
                  zeroPad: true,
                  infiniteLoop: true,
                  itemWidth: 80,
                  itemHeight: 60,
                  onChanged: (value) {
                    ref.read(alarmChangeNotifier.minuteProvider.notifier).state = value;
                  },
                  textStyle: const TextStyle(fontSize: 20, color: Colors.grey),
                  selectedTextStyle: const TextStyle(fontSize: 24, color: Colors.white),
                  decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white), bottom: BorderSide(color: Colors.white))),
                ),
                NumberPicker(
                  minValue: 0,
                  maxValue: 59,
                  value: ref.watch(alarmChangeNotifier.secondProvider),
                  zeroPad: true,
                  infiniteLoop: true,
                  itemWidth: 80,
                  itemHeight: 60,
                  onChanged: (value) {
                    ref.read(alarmChangeNotifier.secondProvider.notifier).state = value;
                  },
                  textStyle: const TextStyle(fontSize: 20, color: Colors.grey),
                  selectedTextStyle: const TextStyle(fontSize: 24, color: Colors.white),
                  decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white), bottom: BorderSide(color: Colors.white))),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Selected Time ${ref.watch(alarmChangeNotifier.hourProvider).toString().padLeft(2, '0')}:${ref.watch(alarmChangeNotifier.minuteProvider).toString().padLeft(2, '0')}:${ref.watch(alarmChangeNotifier.secondProvider).toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
