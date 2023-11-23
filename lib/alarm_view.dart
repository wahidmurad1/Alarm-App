import 'package:alarm_app/alarm_details_page.dart';
import 'package:alarm_app/notification_services.dart';
import 'package:alarm_app/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlarmView extends ConsumerWidget {
  AlarmView({super.key});
  final NotificationServices notificationServices = NotificationServices();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmChangeNotifier = ref.watch(alarmChangeNotifierProvider);
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'Alarm',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            actions: [
              Consumer(
                builder: (context, ref, child) {
                  return IconButton(
                    onPressed: () {
                      ref.invalidate(alarmChangeNotifier.pickedTimeProvider);
                      ref.invalidate(alarmChangeNotifier.tempAlarmActionSelect);
                      ref.invalidate(alarmChangeNotifier.alarmActionSelect);
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlarmDetailsPage()));
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 28,
                      color: Colors.blue,
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: alarmChangeNotifier.alarmList.length,
                  itemBuilder: (context, index) {
                    final switchState = ref.watch(alarmChangeNotifier.switchProvider(index));
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
                              alarmChangeNotifier.alarmList[index].toString(),
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
                                    ref.read(alarmChangeNotifier.switchProvider(index).notifier).state = value;
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
              ElevatedButton(
                  onPressed: () {
                    notificationServices.initializationNotification();
                    notificationServices.sendNotification('alarm', 'Alarm Body');
                  },
                  child: const Text('Notifications')),
            ],
          ),
        ),
      ),
    );
  }
}
