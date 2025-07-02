import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/challenge_model.dart';
import '../services/firestore_service.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final Challenge challenge;

  const ChallengeDetailScreen({super.key, required this.challenge});

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  late Challenge challenge;
  final firestore = FirestoreService();

  @override
  void initState() {
    super.initState();
    challenge = widget.challenge;
  }

  void _toggleDay(int dayIndex) async {
    if (challenge.isLocked) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final allowedDate =
    DateTime(challenge.createdAt.year, challenge.createdAt.month, challenge.createdAt.day)
        .add(Duration(days: dayIndex));

    if (allowedDate.isAfter(today)) return; // Don't allow future dates

    setState(() {
      challenge.progress[dayIndex] = !challenge.progress[dayIndex];
    });

    await firestore.updateChallenge(challenge);
  }

  @override
  Widget build(BuildContext context) {
    final completed = challenge.progress.where((e) => e).length;

    final totalDays = challenge.duration; // Use dynamic duration
    final dayDates = List.generate(
      totalDays,
          (i) => challenge.createdAt.add(Duration(days: i)),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white70),
        title: Text(
          "Habit Progress",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + Lock
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    challenge.title,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  challenge.isLocked ? Icons.lock : Icons.lock_open,
                  color: Colors.white54,
                ),
              ],
            ),

            if (challenge.note.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                challenge.note,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400]),
              ),
            ],

            const SizedBox(height: 12),

            Text(
              "Started on: ${DateFormat.yMMMd().format(challenge.createdAt)}",
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54),
            ),

            const SizedBox(height: 20),

            Text(
              "$completed / $totalDays days completed",
              style: GoogleFonts.poppins(
                color: Colors.deepPurpleAccent,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 16),

            /// Day List with Dates
            Expanded(
              child: ListView.builder(
                itemCount: totalDays,
                itemBuilder: (context, i) {
                  final isDone = challenge.progress[i];
                  final date = dayDates[i];
                  final dayLabel = "Day ${i + 1}";
                  final dateLabel = DateFormat.yMMMd().format(date);

                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);
                  final dayDate = DateTime(date.year, date.month, date.day);
                  final isUnlocked = !challenge.isLocked && dayDate.isBefore(today.add(const Duration(days: 1)));

                  return GestureDetector(
                    onTap: isUnlocked ? () => _toggleDay(i) : null,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDone
                            ? Colors.deepPurpleAccent.withOpacity(0.2)
                            : isUnlocked
                            ? Colors.white10
                            : Colors.black12,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDone
                              ? Colors.deepPurpleAccent
                              : isUnlocked
                              ? Colors.white12
                              : Colors.grey.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isUnlocked
                                ? (isDone ? Icons.check_circle : Icons.circle_outlined)
                                : Icons.lock_outline,
                            color: isUnlocked
                                ? (isDone ? Colors.deepPurpleAccent : Colors.white54)
                                : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dayLabel,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: isUnlocked ? Colors.white : Colors.white38,
                                  ),
                                ),
                                Text(
                                  dateLabel,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: isUnlocked ? Colors.white54 : Colors.white30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
