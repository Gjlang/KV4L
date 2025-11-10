import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models.dart';
import '../data/places.dart';

class ItineraryService {
  /// Build plans for [days] days between [startHour] and [endHour] using
  /// selected [interests] categories (e.g. foodie, culture, insta, family).
  /// Uses shared 'used' set across all days to prevent duplicate places.
  static List<ItineraryPlan> buildPlan({
    required int days,
    required int startHour,
    required int endHour,
    required List<String> interests,
    bool allowRepeatsAfterExhaust = true, // Allow repeats only after all places used
  }) {
    final now = DateTime.now();
    final rand = Random(now.millisecondsSinceEpoch);

    // 1) Filter by interests and shuffle for variety each generation
    final pool = kKLPlaces
        .where((p) => interests.isEmpty || interests.contains(p.category))
        .toList()
      ..shuffle(rand);

    final List<ItineraryPlan> out = [];

    // 2) ❗ Shared 'used' set across ALL days to prevent duplicates
    final used = <String>{};

    for (int d = 0; d < days; d++) {
      final dayStart = DateTime(now.year, now.month, now.day + d, startHour);
      final dayEnd = DateTime(now.year, now.month, now.day + d, endHour);

      DateTime t = dayStart;
      final List<ItineraryStop> stops = [];

      while (t.isBefore(dayEnd)) {
        Place? pick;

        // 3) Find first unused place that fits the time window
        for (final p in pool) {
          if (used.contains(p.id)) continue;

          final visitEnd = t.add(Duration(minutes: p.estMinutes));
          final fitsOpen = t.hour >= p.open;
          final fitsClose = visitEnd.hour < p.close ||
              (visitEnd.hour == p.close && visitEnd.minute == 0);

          if (fitsOpen && fitsClose && !visitEnd.isAfter(dayEnd)) {
            pick = p;
            break;
          }
        }

        // 4) If all places exhausted and repeats allowed -> reset used and continue
        if (pick == null) {
          if (allowRepeatsAfterExhaust && used.length >= pool.length) {
            used.clear(); // Start over with shuffled pool
            continue; // Re-evaluate
          }
          // If repeats not allowed -> stop for this day
          break;
        }

        final end = t.add(Duration(minutes: pick.estMinutes));
        stops.add(ItineraryStop(start: t, end: end, place: pick));
        used.add(pick.id);

        // Simple travel time padding
        t = end.add(const Duration(minutes: 20));
      }

      out.add(ItineraryPlan(dayStart: dayStart, dayEnd: dayEnd, stops: stops));
    }

    return out;
  }

  /// Persist last plan locally (device-only)
  static Future<void> savePlan(List<ItineraryPlan> plans) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = plans
        .map((p) => {
      'dayStart': p.dayStart.toIso8601String(),
      'dayEnd': p.dayEnd.toIso8601String(),
      'stops': p.stops
          .map((s) => {
        'start': s.start.toIso8601String(),
        'end': s.end.toIso8601String(),
        'placeId': s.place.id,
      })
          .toList(),
    })
        .toList();
    await prefs.setString('last_itinerary', jsonEncode(payload));
  }

  /// Load last plan
  static Future<List<ItineraryPlan>?> loadPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('last_itinerary');
    if (raw == null) return null;

    try {
      final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      return list.map((m) {
        final ds = DateTime.parse(m['dayStart']);
        final de = DateTime.parse(m['dayEnd']);
        final stops = (m['stops'] as List).map((s) {
          final start = DateTime.parse(s['start']);
          final end = DateTime.parse(s['end']);
          final place = kKLPlaces.firstWhere((p) => p.id == s['placeId']);
          return ItineraryStop(start: start, end: end, place: place);
        }).toList();
        return ItineraryPlan(dayStart: ds, dayEnd: de, stops: stops);
      }).toList();
    } catch (e) {
      return null;
    }
  }
}