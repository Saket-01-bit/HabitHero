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
    final allowedDate = DateTime(challenge.createdAt.year, challenge.createdAt.month, challenge.createdAt.day)
        .add(Duration(days: dayIndex));

    if (allowedDate.isAfter(today)) return;

    setState(() {
      challenge.progress[dayIndex] = !challenge.progress[dayIndex];
    });

    await firestore.updateChallenge(challenge);
  }

  @override
  Widget build(BuildContext context) {
    final completed = challenge.progress.where((e) => e).length;
    final totalDays = challenge.duration;
    final dayDates = List.generate(totalDays, (i) => challenge.createdAt.add(Duration(days: i)));

    final List<_Reward> rewards = [
      _Reward(day: 1, title: "First Step!", description: "You’ve completed your first day. Great start!", icon: Icons.flag_rounded),
      _Reward(day: 5, title: "Rising Star", description: "Completed 5 days!", icon: Icons.star),
      _Reward(day: 10, title: "Consistency Champ", description: "10 days of effort!", icon: Icons.flash_on),
      _Reward(day: 20, title: "Momentum Builder", description: "20 days strong!", icon: Icons.directions_run),
      _Reward(day: 30, title: "Hero of Habits", description: "30 days completed!", icon: Icons.military_tech),
      _Reward(day: 50, title: "Committed Crusader", description: "50 days done!", icon: Icons.diamond),
      _Reward(day: 100, title: "Century Achiever", description: "100 days habit streak!", icon: Icons.emoji_events),
      _Reward(day: 200, title: "Persistent Powerhouse", description: "200 days completed!", icon: Icons.bolt),
      _Reward(day: 300, title: "Discipline Dominator", description: "300 days of consistency!", icon: Icons.fitness_center),
      _Reward(day: 365, title: "One Year Warrior", description: "365 days – 1 full year!", icon: Icons.cake),
      _Reward(day: 500, title: "Half-Millennium Master", description: "500 days of discipline!", icon: Icons.rocket),
      _Reward(day: 1000, title: "Legend of 1000", description: "1000 days – You’re unstoppable!", icon: Icons.workspace_premium),
    ];

    final highestReward = rewards
        .where((r) => completed >= r.day)
        .fold<_Reward?>(null, (prev, curr) => (prev == null || curr.day > prev.day) ? curr : prev);

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
            /// Header Row with title + reward icon + lock
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
                Row(
                  children: [
                    if (highestReward != null)
                      IconButton(
                        icon: const Icon(Icons.emoji_events, color: Colors.amber, size: 22),
                        tooltip: 'Reward Unlocked!',
                        onPressed: () => _showRewardDialog(context, highestReward),
                      ),
                    Icon(
                      challenge.isLocked ? Icons.lock : Icons.lock_open,
                      color: Colors.white54,
                    ),
                  ],
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

            /// Progress List
            Expanded(
              child: ListView.builder(
                itemCount: totalDays,
                itemBuilder: (context, i) {
                  final isDone = challenge.progress[i];
                  final date = dayDates[i];
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);
                  final isUnlocked = !challenge.isLocked && date.isBefore(today.add(const Duration(days: 1)));

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
                                Text("Day ${i + 1}",
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: isUnlocked ? Colors.white : Colors.white38)),
                                Text(DateFormat.yMMMd().format(date),
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: isUnlocked ? Colors.white54 : Colors.white30)),
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

  void _showRewardDialog(BuildContext context, _Reward reward) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF262638),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(reward.icon, size: 80, color: Colors.amberAccent),
              const SizedBox(height: 20),
              Text(
                reward.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Unlocked after ${reward.day} days",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white60),
              ),
              const SizedBox(height: 16),
              Text(
                reward.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 15, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text("Awesome!", style: TextStyle(fontSize: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Reward {
  final int day;
  final String title;
  final String description;
  final IconData icon;

  _Reward({
    required this.day,
    required this.title,
    required this.description,
    required this.icon,
  });
}

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
