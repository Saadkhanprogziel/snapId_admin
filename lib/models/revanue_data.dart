class RevanueData {
  final String label; // e.g., 'Mon', 'Feb', 'Q1'
  final double amount;

  RevanueData({required this.label, required this.amount});
}

class DocumentData {
  final String label;
  final int count;

  DocumentData({required this.label, required this.count});
}
