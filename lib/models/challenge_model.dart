class Challenge {
  final String id;
  final String title;
  final String note;
  final DateTime createdAt;
  final List<bool> progress;
  final bool isLocked;
  final String userId;
  final int duration;
  final DateTime startDate;
  final String reminderTime; // e.g. "08:00"

  Challenge({
    required this.id,
    required this.title,
    required this.note,
    required this.createdAt,
    required this.progress,
    required this.isLocked,
    required this.userId,
    required this.duration,
    required this.startDate,
    required this.reminderTime,
  });

  List<DateTime> get dayDates =>
      List.generate(duration, (i) => startDate.add(Duration(days: i)));

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
      'progress': progress,
      'isLocked': isLocked,
      'userId': userId,
      'duration': duration,
      'startDate': startDate.toIso8601String(),
      'reminderTime': reminderTime,
    };
  }

  factory Challenge.fromMap(String id, Map<String, dynamic> map) {
    return Challenge(
      id: id,
      title: map['title'] ?? '',
      note: map['note'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      progress: List<bool>.from(map['progress'] ?? List.generate(30, (_) => false)),
      isLocked: map['isLocked'] ?? false,
      userId: map['userId'] ?? '',
      duration: map['duration'] ?? 30,
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'])
          : DateTime.now(),
      reminderTime: map['reminderTime'] ?? '08:00',
    );
  }

  Challenge copyWith({
    String? id,
    String? title,
    String? note,
    DateTime? createdAt,
    List<bool>? progress,
    bool? isLocked,
    String? userId,
    int? duration,
    DateTime? startDate,
    String? reminderTime,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      progress: progress ?? this.progress,
      isLocked: isLocked ?? this.isLocked,
      userId: userId ?? this.userId,
      duration: duration ?? this.duration,
      startDate: startDate ?? this.startDate,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }
}
