import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_set.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final List<GameSet> _gameSets = [];
  final String _storageKey = 'game_sets';
  static const String _versionKey = 'data_version';
  final int _currentVersion = 3;

  List<GameSet> get gameSets => _gameSets;

  Future<void> loadGameSets() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    final bundledSets = await _loadBundledSets();
    final bundledIds = bundledSets.map((set) => set.id).toSet();
    final savedSets =
        jsonString == null ? <GameSet>[] : _decodeSavedSets(jsonString);
    final userSets = savedSets.where((set) => !bundledIds.contains(set.id));

    _gameSets
      ..clear()
      ..addAll(bundledSets)
      ..addAll(userSets)
      ..sort((a, b) => a.id.compareTo(b.id));
    await _saveGameSets();
    await prefs.setInt(_versionKey, _currentVersion);
  }

  Future<List<GameSet>> _loadBundledSets() async {
    final jsonString = await rootBundle.loadString(
      'assets/content/fidel_duel/am.json',
    );
    final decoded = jsonDecode(jsonString) as List;
    return decoded.map((item) => GameSet.fromJson(item)).toList();
  }

  List<GameSet> _decodeSavedSets(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString) as List;
      return decoded.map((item) => GameSet.fromJson(item)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> addGameSet(GameSet set) async {
    _gameSets.add(set);
    _gameSets.sort((a, b) => a.id.compareTo(b.id));
    await _saveGameSets();
  }

  Future<void> _saveGameSets() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_gameSets.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  GameSet? getGameSetById(int id) {
    try {
      return _gameSets.firstWhere((set) => set.id == id);
    } catch (_) {
      return null;
    }
  }

  int getNextId() {
    if (_gameSets.isEmpty) return 1;
    return _gameSets.last.id + 1;
  }
}
