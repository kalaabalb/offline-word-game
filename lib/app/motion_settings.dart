import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MotionSettings {
  static final ValueNotifier<bool> reducedMotion = ValueNotifier(false);
  static const _key = 'reduced_motion';

  static Future<void> load() async {
    reducedMotion.value =
        (await SharedPreferences.getInstance()).getBool(_key) ?? false;
  }

  static Future<void> setReducedMotion(bool value) async {
    reducedMotion.value = value;
    await (await SharedPreferences.getInstance()).setBool(_key, value);
  }
}
