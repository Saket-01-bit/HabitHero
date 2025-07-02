class Challenge {
  final String title;
  final String note;
  final DateTime createdAt;
  final List<bool> progress;
  final bool isLocked;

  Challenge({
    required this.title,
    this.note = '',
    DateTime? createdAt,
    List<bool>? progress,
    this.isLocked = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        progress = progress ?? List<bool>.generate(30, (_) => false);

  Map<String, dynamic> toMap() => {
    'title': title,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
    'progress': progress,
    'isLocked': isLocked,
  };

  factory Challenge.fromMap(Map<String, dynamic> map, Map<String, dynamic> data) => Challenge(
    title: map['title'],
    note: map['note'] ?? '',
    createdAt: DateTime.parse(map['createdAt']),
    progress: List<bool>.from(map['progress']),
    isLocked: map['isLocked'] ?? false,
  );
}
