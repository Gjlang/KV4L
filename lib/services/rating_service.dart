// lib/services/rating_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Local-only ratings (per device).
/// Stores a simple map: placeId -> double (0.0–5.0)
class RatingService {
  static const _kKey = 'ratings.v1';

  static Future<Map<String, double>> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kKey);
    if (raw == null) return {};
    final map = (jsonDecode(raw) as Map<String, dynamic>);
    return map.map((k, v) => MapEntry(k, (v as num).toDouble()));
  }

  static Future<void> _saveAll(Map<String, double> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, jsonEncode(data));
  }

  /// Get rating for a place (returns null if not rated yet).
  static Future<double?> getRating(String placeId) async {
    final all = await _loadAll();
    return all[placeId];
  }

  /// Set/update rating for a place.
  static Future<void> setRating(String placeId, double rating) async {
    final all = await _loadAll();
    all[placeId] = rating.clamp(0.0, 5.0);
    await _saveAll(all);
  }

  /// Remove a rating for a place.
  static Future<void> clearRating(String placeId) async {
    final all = await _loadAll();
    all.remove(placeId);
    await _saveAll(all);
  }

  /// Get all local ratings (for debugging/analytics).
  static Future<Map<String, double>> getAll() => _loadAll();
}
