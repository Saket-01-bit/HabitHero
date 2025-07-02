import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Reward {
  final int day;
  final String title;
  final IconData icon;

  Reward({
    required this.day,
    required this.title,
    required this.icon,
  });
}

final List<Reward> rewards = [
  Reward(day: 1, title: "First Step!", icon: Icons.flag_rounded),
  Reward(day: 5, title: "Rising Star", icon: Icons.star),
  Reward(day: 10, title: "Consistency Champ", icon: Icons.flash_on),
  Reward(day: 20, title: "Momentum Builder", icon: Icons.directions_run),
  Reward(day: 30, title: "Hero of Habits", icon: Icons.military_tech),
  Reward(day: 50, title: "Committed Crusader", icon: Icons.diamond),
  Reward(day: 100, title: "Century Achiever", icon: Icons.emoji_events),
  Reward(day: 200, title: "Persistent Powerhouse", icon: Icons.bolt),
  Reward(day: 300, title: "Discipline Dominator", icon: Icons.fitness_center),
  Reward(day: 365, title: "One Year Warrior", icon: Icons.cake),
  Reward(day: 500, title: "Half-Millennium Master", icon: Icons.rocket),
  Reward(day: 1000, title: "Legend of 1000", icon: Icons.workspace_premium),
];

void showAllRewardsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: const Color(0xFF2E2E3E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "🏆 All Rewards",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 400,
                child: ListView.builder(
                  itemCount: rewards.length,
                  itemBuilder: (context, i) {
                    final reward = rewards[i];
                    return ListTile(
                      leading: Icon(reward.icon, color: Colors.amber),
                      title: Text(
                        reward.title,
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      subtitle: Text(
                        "Unlocked at ${reward.day} days",
                        style: GoogleFonts.poppins(
                            color: Colors.white70, fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Close"),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
