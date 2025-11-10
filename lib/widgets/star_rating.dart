// lib/widgets/star_rating.dart
import 'package:flutter/material.dart';

/// A simple, tappable 5-star rating bar that supports half-stars.
/// - `value`: current rating (0.0–5.0)
/// - `onChanged`: callback when user taps/updates the rating
class StarRating extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final bool readOnly;

  const StarRating({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 24,
    this.activeColor = const Color(0xFFFFB300), // amber-ish
    this.inactiveColor = const Color(0xFFCFD8DC), // blue-grey 100
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    // Build 5 stars with half support
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      final starValue = i.toDouble();
      final isFull = value >= starValue;
      final isHalf = !isFull && (value >= (starValue - 0.5));

      Widget icon;
      if (isFull) {
        icon = Icon(Icons.star, size: size, color: activeColor);
      } else if (isHalf) {
        icon = Stack(
          alignment: Alignment.centerLeft,
          children: [
            Icon(Icons.star_border, size: size, color: inactiveColor),
            ClipRect(
              clipper: _HalfClipper(),
              child: Icon(Icons.star, size: size, color: activeColor),
            ),
          ],
        );
      } else {
        icon = Icon(Icons.star_border, size: size, color: inactiveColor);
      }

      if (readOnly) {
        stars.add(icon);
      } else {
        stars.add(GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) {
            // half vs full detection based on tap position
            final box = context.findRenderObject() as RenderBox?;
            final local = box?.globalToLocal(d.globalPosition);
            final dx = local?.dx ?? 0;
            // If tapped on left half → .5; right half → .0 of this star
            final half = dx < (size / 2);
            final newValue = half ? (starValue - 0.5) : starValue;
            onChanged(newValue);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: icon,
          ),
        ));
      }
    }

    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width / 2, size.height);
  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}
