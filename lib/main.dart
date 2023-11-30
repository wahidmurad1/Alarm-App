import 'package:alarm/alarm.dart';
import 'package:alarm_app/consts/routes.dart';
import 'package:alarm_app/providers.dart';
import 'package:alarm_app/theme/dark_theme.dart';
import 'package:alarm_app/theme/light_theme.dart';
import 'package:alarm_app/consts/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init(showDebugLogs: true);
  //* status bar theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmChangeNotifier = ref.watch(alarmChangeNotifierProvider);
    heightWidthKeyboardValue(context);
    return MaterialApp.router(
      title: 'Alarm App',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: false,
      // ),
      // themeMode: ThemeMode.system,
      theme: alarmChangeNotifier.themeType == true ? darkTheme : lightTheme,
      // theme: lightTheme,
      // darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      // home: AlarmPage(),
      routerConfig: goRouter,
    );
  }
}
