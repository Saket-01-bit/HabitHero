import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../dialogs/rewards_dialog.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped, required void Function() onRewardsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF2E2E3E),
      selectedItemColor: Colors.deepPurpleAccent,
      unselectedItemColor: Colors.white70,
      currentIndex: selectedIndex,
      onTap: (index) async {
        switch (index) {
          case 0:
            showAllRewardsDialog(context);
            break;
          case 1:
            Navigator.pushNamed(context, '/profile');
            break;
          case 2:
            await FirebaseAuth.instance.signOut();
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            }
            break;
        }
        onItemTapped(index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events),
          label: 'Rewards',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
    );
  }
}