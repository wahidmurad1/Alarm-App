import 'package:alarm_app/alarm_details_page.dart';
import 'package:alarm_app/alarm_list_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlarmView extends ConsumerWidget {
  const AlarmView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmList = ref.watch(alarmListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alarm',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // ref.read(alarmListProvider.notifier).add('6:00 AM');
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AlarmDetailsPage()));
            },
            icon: const Icon(
              Icons.add,
              size: 28,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: alarmList.length,
              itemBuilder: (context, index) {
                final switchState = ref.watch(switchProvider(index));
                return Padding(
                  padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          alarmList[index].toString(),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 50,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: CupertinoSwitch(
                              activeColor: Colors.blue,
                              trackColor: const Color.fromARGB(255, 220, 218, 218),
                              value: switchState,
                              onChanged: (value) {
                                ref.read(switchProvider(index).notifier).state = value;
                              },
                              // activeTrackColor: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Divider(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
