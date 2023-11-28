import 'package:alarm/alarm.dart';
import 'package:alarm_app/providers.dart';
import 'package:alarm_app/theme/dark_theme.dart';
import 'package:alarm_app/theme/light_theme.dart';
import 'package:alarm_app/views/alarm_page.dart';
import 'package:alarm_app/consts/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init(showDebugLogs: true);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmChangeNotifier = ref.watch(alarmChangeNotifierProvider);
    heightWidthKeyboardValue(context);
    return MaterialApp(
      title: 'Alarm App',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: false,
      // ),
      // themeMode: ThemeMode.system,
      theme: ref.watch(alarmChangeNotifier.themeTypeProvider) == true ? darkTheme : lightTheme,
      debugShowCheckedModeBanner: false,
      home: AlarmPage(),
    );
  }
}
