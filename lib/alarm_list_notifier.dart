import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlarmListNotifier extends StateNotifier<List<String>> {
  AlarmListNotifier() : super([]);

  void add(String value) {
    state = [...state, value];
  }
}

final alarmListProvider = StateNotifierProvider<AlarmListNotifier, List<String>>((ref) => AlarmListNotifier());
final switchProvider = StateProvider.family<bool, int>((ref, index) {
  return true;
});
final hour = Provider<int>((ref) {
  return 0;
});
final minute = Provider<int>((ref) {
  return 0;
});
