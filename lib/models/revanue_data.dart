class RevenueData {
  final String label; // e.g., 'Mon', 'Feb', 'Q1'
  final double amount;

  RevenueData({required this.label, required this.amount});
}

class DocumentData {
  final String label;
  final int count;

  DocumentData({required this.label, required this.count});
}
