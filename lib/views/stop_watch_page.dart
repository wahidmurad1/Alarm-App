import 'package:alarm_app/consts/const.dart';
import 'package:alarm_app/notifiers/providers.dart';
import 'package:alarm_app/sp_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class StopWatchPage extends ConsumerWidget {
  const StopWatchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmChangeNotifier = ref.watch(alarmChangeNotifierProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
            onPressed: () async {
              ref.read(alarmChangeNotifier.themeTypeProvider.notifier).state = !ref.read(alarmChangeNotifier.themeTypeProvider.notifier).state;
              alarmChangeNotifier.themeType = ref.watch(alarmChangeNotifier.themeTypeProvider);
              alarmChangeNotifier.updateState();
              await SpController().saveThemeType(ref.watch(alarmChangeNotifier.themeTypeProvider));
            },
            icon: alarmChangeNotifier.themeType == true
                ? const Icon(
                    CupertinoIcons.brightness,
                    color: cWhiteColor,
                  )
                : const Icon(
                    CupertinoIcons.moon_stars_fill,
                    color: cBlackColor,
                  )),
        title: Text(
          'Stop Watch',
          style: semiBold18TextStyle(Theme.of(context).colorScheme.primary),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder(
                stream: alarmChangeNotifier.stopWatchTimer.rawTime,
                initialData: alarmChangeNotifier.stopWatchTimer.rawTime.value,
                builder: (context, snapshot) {
                  final value = snapshot.data;
                  final displayTime = StopWatchTimer.getDisplayTime(value!, hours: alarmChangeNotifier.isHour);
                  return Center(
                      child: Text(
                    displayTime,
                    style: semiBold20TextStyle(Theme.of(context).colorScheme.primary),
                  ));
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    if (ref.watch(alarmChangeNotifier.isPlay)) {
                      alarmChangeNotifier.stopWatchTimer.onStartTimer();
                    } else {
                      alarmChangeNotifier.stopWatchTimer.onStopTimer();
                    }
                    ref.read(alarmChangeNotifier.isPlay.notifier).state = !ref.read(alarmChangeNotifier.isPlay.notifier).state;
                  },
                  icon: Icon(
                    ref.watch(alarmChangeNotifier.isPlay) ? Icons.play_circle : Icons.pause_circle,
                    color: cPrimaryColor,
                  )),
              ref.watch(alarmChangeNotifier.isPlay)
                  ? IconButton(
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        alarmChangeNotifier.stopWatchTimer.onResetTimer();
                      },
                      icon: const Icon(
                        CupertinoIcons.restart,
                        size: 20,
                      ))
                  : const SizedBox(),
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
