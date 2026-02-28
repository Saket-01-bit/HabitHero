import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/challenge_model.dart';
import '../screens/challenge_detail_screen.dart';
import '../services/firestore_service.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService firestore = FirestoreService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  int _selectedIndex = 0;

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
      appBar: _buildAppBar(),
      floatingActionButton: _buildFAB(context),
      body: _buildChallengeList(),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) => setState(() => _selectedIndex = index),
        onRewardsPressed: _showAllRewardsDialog,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 120,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white70),
          onPressed: _showLogoutDialog,
        ),
      ],
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Image(image: AssetImage('assets/logo.png'), width: 40, height: 40),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("HabitHero 🦸",
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text("Build winning habits, one day at a time",
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.grey[400])),
              ],
            ),
          ),
        ],
      ),
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
              prefixIcon:
              const Icon(Icons.search, color: Colors.white54),
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
    );
  }

  // ✅ Logout Confirmation Dialog
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF2E2E3E),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout,
                  color: Colors.deepPurpleAccent, size: 40),
              const SizedBox(height: 16),
              Text(
                "Log Out?",
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                "Are you sure you want to log out of HabitHero?",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 14, color: Colors.grey[400]),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Colors.white24),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10)),
                      ),
                      child: const Text("Cancel",
                          style:
                          TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(
                            context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10)),
                      ),
                      child: const Text("Log Out"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // ----------- (Rest of your original code remains unchanged) -----------

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.deepPurpleAccent,
      onPressed: () => Navigator.pushNamed(context, '/create'),
      icon: const Icon(Icons.add),
      label: const Text("Add Habit"),
    );
  }

  Widget _buildChallengeList() {
    return StreamBuilder<List<Challenge>>(
      stream: firestore.getChallenges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }

        final filtered = snapshot.data!
            .where((c) =>
            c.title.toLowerCase().contains(_searchQuery))
            .toList();

        if (filtered.isEmpty) {
          return Center(
              child: Text("No results found.",
                  style: GoogleFonts.poppins(
                      color: Colors.grey[400])));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (context, index) =>
              _buildChallengeCard(
                  context, filtered[index]),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty_rounded,
              size: 80,
              color: Colors.deepPurpleAccent
                  .withOpacity(0.5)),
          const SizedBox(height: 20),
          Text(
            "No habits yet.\nTap '+' to begin your journey!",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(
      BuildContext context,
      Challenge challenge) {
    final totalDays = challenge.duration;
    final progressCount =
        challenge.progress.where((e) => e).length;
    final progress =
    totalDays > 0 ? progressCount / totalDays : 0.0;

    return Container(); // shortened for clarity (keep your original card code here)
  }

  void _showAllRewardsDialog() {}

}

class _Reward {
  final int day;
  final String title;
  final IconData icon;

  _Reward(
      {required this.day,
        required this.title,
        required this.icon});
}