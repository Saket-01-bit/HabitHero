import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../models/challenge_model.dart';
import '../services/firestore_service.dart';

class CreateChallengeScreen extends StatefulWidget {
  @override
  _CreateChallengeScreenState createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedEmoji = '🔥';
  int _duration = 30;
  DateTime _startDate = DateTime.now();
  TimeOfDay _reminderTime = TimeOfDay(hour: 8, minute: 0);
  bool _isLocked = false;

  final _firestoreService = FirestoreService();

  final List<int> _durationOptions = [7, 14, 21, 30, 50, 100, 200, 300, 365, 500, 1000];

  final List<String> _emojiOptions = [
    '🔥', '💪', '📚', '🥗', '🧘', '🚰', '🛏️', '🧠', '☀️'
  ];

  final Map<String, String> _emojiLabels = {
    '🔥': 'Motivation',
    '💪': 'Workout',
    '📚': 'Study',
    '🥗': 'Healthy Eating',
    '🧘': 'Meditation',
    '🚰': 'Hydration',
    '🛏️': 'Sleep',
    '🧠': 'Mindset',
    '☀️': 'Morning Routine',
  };

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null) setState(() => _reminderTime = picked);
  }

  Future<void> _saveChallenge() async {
    final title = _titleController.text.trim();
    final note = _noteController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    if (title.isEmpty || user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a title and make sure you're logged in.")),
      );
      return;
    }

    if (_duration > 300) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Confirm Long Duration"),
          content: Text("Are you sure you want to create a $_duration-day habit?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel")),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text("Confirm")),
          ],
        ),
      );
      if (confirm != true) return;
    }

    final newChallenge = Challenge(
      id: '',
      title: "$_selectedEmoji $title",
      note: note,
      progress: List.generate(_duration, (_) => false),
      createdAt: DateTime.now(),
      startDate: DateTime.now(), // ← Add this
      reminderTime: '08:00',     // ← And this, optionally use user input later
      isLocked: false,
      userId: user.uid,
      duration: _duration,
    );


    await _firestoreService.addChallenge(newChallenge);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeTextStyle = GoogleFonts.poppins(color: Colors.white, fontSize: 16);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        title: Text("New Habit", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _buildLabel("Title"),
            _buildTextField(_titleController, "e.g. Morning Walk"),
            _buildLabel("Optional Note/Description"),
            _buildTextField(_noteController, "e.g. Walk 5k steps before 8am", maxLines: 3),
            _buildLabel("Pick a Category"),
            _buildDropdown<String>(
              value: _selectedEmoji,
              items: _emojiOptions,
              display: (e) => "$e  ${_emojiLabels[e] ?? ''}",
              onChanged: (e) => _selectedEmoji = e!,
            ),
            Center(child: Text(_emojiLabels[_selectedEmoji] ?? '', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14, fontStyle: FontStyle.italic))),
            _buildLabel("Select Duration"),
            _buildDropdown<int>(
              value: _duration,
              items: _durationOptions,
              display: (d) => "$d days",
              onChanged: (d) => _duration = d!,
            ),
            Center(child: Text("This habit will last for $_duration days.", style: TextStyle(color: Colors.white54, fontSize: 14))),
            _buildLabel("Start Date"),
            ListTile(
              title: Text(DateFormat.yMMMd().format(_startDate), style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.calendar_today, color: Colors.white),
              onTap: _pickStartDate,
            ),
            _buildLabel("Daily Reminder Time"),
            ListTile(
              title: Text("${_reminderTime.format(context)}", style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.alarm, color: Colors.white),
              onTap: _pickReminderTime,
            ),
            SwitchListTile(
              value: _isLocked,
              onChanged: (v) => setState(() => _isLocked = v),
              activeColor: Colors.deepPurpleAccent,
              title: Text("Lock this habit from editing", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: Icon(Icons.check),
              label: Text("Create Habit", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
              onPressed: _saveChallenge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(text, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16)),
  );

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) => TextField(
    controller: controller,
    style: TextStyle(color: Colors.white),
    maxLines: maxLines,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white10,
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white38),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) display,
    required void Function(T?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          dropdownColor: Color(0xFF2E2E3E),
          iconEnabledColor: Colors.white,
          style: TextStyle(color: Colors.white, fontSize: 16),
          items: items.map((item) => DropdownMenuItem<T>(
            value: item,
            child: Text(display(item)),
          )).toList(),
          onChanged: (val) => setState(() => onChanged(val)),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}
