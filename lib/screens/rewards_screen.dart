import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RewardsScreen extends StatelessWidget {
  final int totalDaysCompleted;

  const RewardsScreen({super.key, required this.totalDaysCompleted});

  @override
  Widget build(BuildContext context) {
    final List<_Reward> rewards = [
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

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text("Your Rewards"),
        backgroundColor: const Color(0xFF1E1E2C),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: rewards.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final reward = rewards[index];
          final isUnlocked = totalDaysCompleted >= reward.day;

          return GestureDetector(
            onTap: isUnlocked
                ? () => _showRewardDialog(context, reward)
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? Colors.deepPurple.withOpacity(0.2)
                    : Colors.white10,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isUnlocked ? Colors.deepPurpleAccent : Colors.white12,
                  width: 1.2,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(
                    reward.icon,
                    color: isUnlocked ? Colors.amber : Colors.grey,
                    size: 30,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reward.title,
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isUnlocked ? Colors.white : Colors.white54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reward.description,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: isUnlocked ? Colors.white70 : Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isUnlocked ? Icons.check_circle : Icons.lock_outline,
                    color: isUnlocked ? Colors.greenAccent : Colors.grey,
                  ),
                ],
              ),
            ),
          );
        },
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
              Icon(
                reward.icon,
                size: 80,
                color: Colors.amberAccent,
              ),
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
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                reward.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
