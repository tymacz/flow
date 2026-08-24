class HistoryItem {
  final String title;
  final String type;
  final String date;

  HistoryItem({required this.title, required this.type, required this.date});

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      title: json['title'] ?? '',
      type: json['type'] ?? 'Activité',
      date: json['date'] ?? '',
    );
  }
}

class ProgressData {
  final double score;
  final List<int> weekMoods;
  final String consecutiveDays;
  final String totalSessions;
  final String totalTime;
  final List<HistoryItem> history;

  ProgressData({
    required this.score,
    required this.weekMoods,
    required this.consecutiveDays,
    required this.totalSessions,
    required this.totalTime,
    required this.history,
  });

  factory ProgressData.fromJson(Map<String, dynamic> json) {
    return ProgressData(
      score: (json['score'] ?? 0).toDouble(),
      weekMoods: List<int>.from(json['week_moods'] ?? [0,0,0,0,0,0,0]),
      consecutiveDays: json['stats']['consecutive_days'] ?? '0 jours',
      totalSessions: json['stats']['total_sessions'] ?? '0 séances',
      totalTime: json['stats']['total_time'] ?? '0 min',
      history: (json['history'] as List?)
          ?.map((item) => HistoryItem.fromJson(item))
          .toList() ?? [],
    );
  }
}