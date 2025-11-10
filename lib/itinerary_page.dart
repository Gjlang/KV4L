import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// PDF + printing + share
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';

import 'models.dart';
import 'services/itinerary_service.dart';

class ItineraryPage extends StatefulWidget {
  const ItineraryPage({super.key});
  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  int _days = 1;
  int _startHour = 9;
  int _endHour = 18;
  final Set<String> _interests = {'foodie', 'culture', 'insta', 'family'};

  List<ItineraryPlan>? _plans;

  Future<void> _generate() async {
    final plans = ItineraryService.buildPlan(
      days: _days,
      startHour: _startHour,
      endHour: _endHour,
      interests: _interests.toList(),
    );
    await ItineraryService.savePlan(plans);
    setState(() => _plans = plans);
  }

  Future<void> _loadLast() async {
    final last = await ItineraryService.loadPlan();
    setState(() => _plans = last);
  }

  Future<void> _downloadPdf() async {
    if (_plans == null || _plans!.isEmpty) return;

    final pdf = pw.Document();
    final df = DateFormat('EEE, d MMM yyyy');
    final tf = DateFormat('HH:mm');

    for (final day in _plans!) {
      pdf.addPage(
        pw.Page(
          margin: const pw.EdgeInsets.all(24),
          pageFormat: PdfPageFormat.a4,
          build: (ctx) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('KL Trip Plan',
                    style: pw.TextStyle(
                        fontSize: 22, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                pw.Text('${df.format(day.dayStart)}  '
                    '${tf.format(day.dayStart)}–${tf.format(day.dayEnd)}'),
                pw.SizedBox(height: 16),
                ...day.stops.map((s) => pw.Container(
                      padding: const pw.EdgeInsets.symmetric(vertical: 6),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(
                              width: 90,
                              child: pw.Text(
                                  '${tf.format(s.start)}–${tf.format(s.end)}')),
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(s.place.name,
                                    style: pw.TextStyle(
                                        fontSize: 14,
                                        fontWeight: pw.FontWeight.bold)),
                                pw.Text(
                                    'Category: ${s.place.category.toUpperCase()}'),
                                pw.Text(
                                    'Suggested: ${s.place.estMinutes} mins'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            );
          },
        ),
      );
    }

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/KL_Itinerary.pdf');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)], text: 'My KL itinerary');
  }

  @override
  void initState() {
    super.initState();
    _loadLast();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cityGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [const Color(0xFF1a1a2e), const Color(0xFF16213e)]
          : [const Color(0xFFf8f9fa), const Color(0xFFe9ecef)],
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: cityGradient),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Modern App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'Kuala Lumpur',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: _plans == null ? null : _downloadPdf,
                    icon: const Icon(Icons.ios_share_rounded),
                    tooltip: 'Share Itinerary',
                  ),
                ],
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Trip Duration Section
                      _SectionHeader(
                        icon: Icons.calendar_today_rounded,
                        title: 'Trip Duration',
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.black.withOpacity(0.05),
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            _DayButton(
                              label: '1 Day',
                              isSelected: _days == 1,
                              onTap: () => setState(() => _days = 1),
                            ),
                            const SizedBox(width: 12),
                            _DayButton(
                              label: '2 Days',
                              isSelected: _days == 2,
                              onTap: () => setState(() => _days = 2),
                            ),
                            const SizedBox(width: 12),
                            _DayButton(
                              label: '3 Days',
                              isSelected: _days == 3,
                              onTap: () => setState(() => _days = 3),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Time Window Section
                      _SectionHeader(
                        icon: Icons.access_time_rounded,
                        title: 'Daily Schedule',
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.black.withOpacity(0.05),
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _ModernTimeField(
                                label: 'Start',
                                value: _startHour,
                                onChanged: (v) =>
                                    setState(() => _startHour = v),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            Expanded(
                              child: _ModernTimeField(
                                label: 'End',
                                value: _endHour,
                                onChanged: (v) => setState(() => _endHour = v),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Interests Section
                      _SectionHeader(
                        icon: Icons.favorite_rounded,
                        title: 'Your Interests',
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _InterestChip(
                            label: '🍜 Foodie',
                            isSelected: _interests.contains('foodie'),
                            onTap: () => setState(() =>
                                _interests.contains('foodie')
                                    ? _interests.remove('foodie')
                                    : _interests.add('foodie')),
                          ),
                          _InterestChip(
                            label: '🏛️ Culture',
                            isSelected: _interests.contains('culture'),
                            onTap: () => setState(() =>
                                _interests.contains('culture')
                                    ? _interests.remove('culture')
                                    : _interests.add('culture')),
                          ),
                          _InterestChip(
                            label: '📸 Insta-worthy',
                            isSelected: _interests.contains('insta'),
                            onTap: () => setState(() =>
                                _interests.contains('insta')
                                    ? _interests.remove('insta')
                                    : _interests.add('insta')),
                          ),
                          _InterestChip(
                            label: '👨‍👩‍👧 Family',
                            isSelected: _interests.contains('family'),
                            onTap: () => setState(() =>
                                _interests.contains('family')
                                    ? _interests.remove('family')
                                    : _interests.add('family')),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Generate Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _generate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? const Color(0xFF4a90e2)
                                : const Color(0xFF2c3e50),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.explore_rounded),
                              SizedBox(width: 12),
                              Text(
                                'Generate Itinerary',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Itinerary Results
                      if (_plans != null) ...[
                        _SectionHeader(
                          icon: Icons.map_rounded,
                          title: 'Your Itinerary',
                        ),
                        const SizedBox(height: 12),
                        ..._plans!.asMap().entries.map((entry) {
                          final dayIdx = entry.key + 1;
                          final plan = entry.value;
                          return _ModernDayCard(
                            dayIdx: dayIdx,
                            plan: plan,
                            isDark: isDark,
                          );
                        }),
                      ],

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: Colors.grey.shade600,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _DayButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? const Color(0xFF4a90e2) : const Color(0xFF2c3e50))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : (isDark
                      ? Colors.white.withOpacity(0.2)
                      : Colors.grey.shade300),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white70 : Colors.black87),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _ModernTimeField extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _ModernTimeField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color:
                isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: value,
              isDense: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade600),
              items: List.generate(
                24,
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text(
                    '${i.toString().padLeft(2, '0')}:00',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              onChanged: (v) => onChanged(v ?? value),
            ),
          ),
        ),
      ],
    );
  }
}

class _InterestChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _InterestChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF4a90e2) : const Color(0xFF2c3e50))
              : (isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white.withOpacity(0.8)),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.grey.shade300),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white70 : Colors.black87),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _ModernDayCard extends StatelessWidget {
  final int dayIdx;
  final ItineraryPlan plan;
  final bool isDark;

  const _ModernDayCard({
    required this.dayIdx,
    required this.plan,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final tf = DateFormat('HH:mm');
    final df = DateFormat('EEE, d MMM');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color:
                  isDark ? Colors.white.withOpacity(0.03) : Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF4a90e2)
                        : const Color(0xFF2c3e50),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '$dayIdx',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Day $dayIdx',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      df.format(plan.dayStart),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Stops
          if (plan.stops.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'No matching places found. Try adjusting your preferences.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: plan.stops.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final stop = plan.stops[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline
                    Column(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF4a90e2)
                                : const Color(0xFF2c3e50),
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (index < plan.stops.length - 1)
                          Container(
                            width: 2,
                            height: 40,
                            color: isDark
                                ? Colors.white.withOpacity(0.2)
                                : Colors.grey.shade300,
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),

                    // Time
                    SizedBox(
                      width: 70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tf.format(stop.start),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            tf.format(stop.end),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Place Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stop.place.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  stop.place.category.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.grey.shade700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.schedule_rounded,
                                size: 12,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${stop.place.estMinutes} mins',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
