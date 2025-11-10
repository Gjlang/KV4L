class Place {
  final String id;
  final String name;
  final String category; // foodie, culture, insta, family
  final double lat;
  final double lng;
  final int estMinutes; // suggested visit time
  final int open; // hour 0–24
  final int close; // hour 0–24
  final List<String> tags;
  const Place({
    required this.id,
    required this.name,
    required this.category,
    required this.lat,
    required this.lng,
    required this.estMinutes,
    required this.open,
    required this.close,
    required this.tags,
  });
}

class ItineraryStop {
  final DateTime start;
  final DateTime end;
  final Place place;
  const ItineraryStop(
      {required this.start, required this.end, required this.place});
}

class ItineraryPlan {
  final DateTime dayStart;
  final DateTime dayEnd;
  final List<ItineraryStop> stops;
  const ItineraryPlan(
      {required this.dayStart, required this.dayEnd, required this.stops});
}


