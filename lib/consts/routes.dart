import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm_app/views/alarm_details_page.dart';
import 'package:alarm_app/views/alarm_page.dart';
import 'package:alarm_app/views/alarm_ring_page.dart';
import 'package:alarm_app/views/stop_watch_page.dart';
import 'package:alarm_app/views/timer_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const krAlarm = '/';
const krAlarmDetails = '/alarm-details';
const krAlarmRing = '/ring-alarm';

final routes = [
  GoRoute(
    path: krAlarm,
    pageBuilder: (context, state) => MaterialPage(child: AlarmPage()),
  ),
  GoRoute(
    path: krAlarmDetails,
    pageBuilder: (context, state) => MaterialPage(child: AlarmDetailsPage()),
  ),
  GoRoute(
    path: krAlarmRing,
    pageBuilder: (context, state) {
      AlarmSettings alarmSettings = state.extra as AlarmSettings;
      return MaterialPage(child: AlarmRingScreen(alarmSettings: alarmSettings));
    },
  ),
];

final goRouter = GoRouter(
  routes: routes,
);
