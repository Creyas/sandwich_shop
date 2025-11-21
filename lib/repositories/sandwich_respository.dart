import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/sandwich.dart';

class SandwichRepository {
  List<Sandwich>? _cache;

  SandwichRepository();

  /// Load all sandwiches from assets (cached after first load).
  Future<List<Sandwich>> loadAll() async {
    if (_cache != null) return _cache!;
    final jsonText = await rootBundle.loadString('assets/sandwiches.json');
    final Map<String, dynamic> data = jsonDecode(jsonText) as Map<String, dynamic>;
    final List<dynamic> list = data['sandwiches'] as List<dynamic>;
    _cache = list.map((e) => Sandwich.fromJson(e as Map<String, dynamic>)).toList();
    return _cache!;
  }

  /// Convenience alias
  Future<List<Sandwich>> getAllSandwiches() => loadAll();

  /// Find one by id, or return null if not found.
  Future<Sandwich?> getById(String id) async {
    final all = await loadAll();
    try {
      return all.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Clear the in-memory cache (useful for tests or refresh).
  void clearCache() => _cache = null;
}