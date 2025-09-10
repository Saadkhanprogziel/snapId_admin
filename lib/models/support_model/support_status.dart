class SupportStatuses {
  final int totalCount;
  final int pendingCount;
  final int openCount;
  final int closeCount;

  SupportStatuses({
    required this.totalCount,
    required this.pendingCount,
    required this.openCount,
    required this.closeCount,
  });

  factory SupportStatuses.fromJson(Map<String, dynamic> json) {
    return SupportStatuses(
      totalCount: json['totalCount'] ?? 0,
      pendingCount: json['pendingCount'] ?? 0,
      openCount: json['openCount'] ?? 0,
      closeCount: json['closeCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'pendingCount': pendingCount,
      'openCount': openCount,
      'closeCount': closeCount,
    };
  }

  @override
  String toString() {
    return 'SupportStatuses(totalCount: $totalCount, pendingCount: $pendingCount, openCount: $openCount, closeCount: $closeCount)';
  }
}
