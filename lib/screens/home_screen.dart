import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/challenge_model.dart';
import '../screens/challenge_detail_screen.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService firestore = FirestoreService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final List<_Reward> rewards = [
    _Reward(day: 1, title: "First Step!", icon: Icons.flag_rounded),
    _Reward(day: 5, title: "Rising Star", icon: Icons.star),
    _Reward(day: 10, title: "Consistency Champ", icon: Icons.flash_on),
    _Reward(day: 20, title: "Momentum Builder", icon: Icons.directions_run),
    _Reward(day: 30, title: "Hero of Habits", icon: Icons.military_tech),
    _Reward(day: 50, title: "Committed Crusader", icon: Icons.diamond),
    _Reward(day: 100, title: "Century Achiever", icon: Icons.emoji_events),
    _Reward(day: 200, title: "Persistent Powerhouse", icon: Icons.bolt),
    _Reward(day: 300, title: "Discipline Dominator", icon: Icons.fitness_center),
    _Reward(day: 365, title: "One Year Warrior", icon: Icons.cake),
    _Reward(day: 500, title: "Half-Millennium Master", icon: Icons.rocket),
    _Reward(day: 1000, title: "Legend of 1000", icon: Icons.workspace_premium),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Image(
                  image: AssetImage('assets/logo.png'),
                  width: 40,
                  height: 40,
                ),
                Text(
                  "HabitHero 🦸",
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Text(
              "Build winning habits, one day at a time",
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events, color: Colors.amber),
            tooltip: 'View Rewards',
            onPressed: _showAllRewardsDialog,
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            tooltip: 'Profile',
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Log out',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) =>
                  setState(() => _searchQuery = value.toLowerCase()),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search habits...",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFAB(context),
      body: StreamBuilder<List<Challenge>>(
        stream: firestore.getChallenges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final challenges = snapshot.data!;
          final filtered = challenges.where((c) {
            return c.title.toLowerCase().contains(_searchQuery);
          }).toList();

          if (filtered.isEmpty) {
            return Center(
              child: Text(
                "No results found.",
                style: GoogleFonts.poppins(color: Colors.grey[400]),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              return _buildChallengeCard(context, filtered[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.deepPurpleAccent,
      onPressed: () => Navigator.pushNamed(context, '/create'),
      icon: const Icon(Icons.add),
      label: const Text("Add Habit"),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty_rounded,
              size: 80, color: Colors.deepPurpleAccent.withOpacity(0.5)),
          const SizedBox(height: 20),
          Text(
            "No habits yet.\nTap '+' to begin your journey!",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(BuildContext context, Challenge challenge) {
    final totalDays = challenge.duration;
    final progressCount = challenge.progress.where((e) => e).length;
    final double progress = totalDays > 0 ? progressCount / totalDays : 0.0;

    return GestureDetector(
      onTap: challenge.isLocked
          ? null
          : () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChallengeDetailScreen(challenge: challenge),
          ),
        );
      },
      child: Opacity(
        opacity: challenge.isLocked ? 0.6 : 1.0,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple.withOpacity(0.3),
                Colors.deepPurpleAccent.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurpleAccent.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    challenge.title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (challenge.isLocked)
                  const Icon(Icons.lock, color: Colors.white60, size: 18),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  color: Colors.deepPurpleAccent,
                  backgroundColor: Colors.white10,
                  minHeight: 6,
                ),
                const SizedBox(height: 6),
                Text(
                  "$progressCount of ${challenge.duration} days complete",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) async {
                if (value == 'delete') {
                  await firestore.deleteChallenge(challenge.id);
                } else if (value == 'toggleLock') {
                  final updated = challenge.copyWith(isLocked: !challenge.isLocked);
                  await firestore.updateChallenge(updated);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
                PopupMenuItem(
                  value: 'toggleLock',
                  child: Text(challenge.isLocked ? 'Unlock' : 'Lock'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAllRewardsDialog() {
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
}

class _Reward {
  final int day;
  final String title;
  final IconData icon;

  _Reward({
    required this.day,
    required this.title,
    required this.icon,
  });
}
