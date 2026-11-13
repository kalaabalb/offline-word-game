import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class JebenaStorage {
  const JebenaStorage();

  Future<String?> readString(String key) async =>
      (await SharedPreferences.getInstance()).getString(key);

  Future<void> writeString(String key, String value) async =>
      (await SharedPreferences.getInstance()).setString(key, value);

  Future<Map<String, dynamic>?> readJson(String key) async {
    final value = await readString(key);
    if (value == null) return null;
    return jsonDecode(value) as Map<String, dynamic>;
  }

  Future<void> writeJson(String key, Map<String, dynamic> value) =>
      writeString(key, jsonEncode(value));

  Future<List<Map<String, dynamic>>> readJsonList(String key) async {
    final value = await readString(key);
    if (value == null) return [];
    return (jsonDecode(value) as List)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  Future<void> writeJsonList(
    String key,
    List<Map<String, dynamic>> values,
  ) =>
      writeString(key, jsonEncode(values));
}
