class SummaryData {
  final int executedToday;
  final int pendingToday;

  const SummaryData({
    required this.executedToday,
    required this.pendingToday,
  });

  factory SummaryData.fromJson(Map<String, dynamic> json) {
    return SummaryData(
      executedToday: json['executed_today'] as int? ?? 0,
      pendingToday: json['pending_today'] as int? ?? 0,
    );
  }
}
