class TicketGraph {
  final int totalTickets;
  final List<Ticket> allTickets;

  TicketGraph({
    required this.totalTickets,
    required this.allTickets,
  });

  factory TicketGraph.fromJson(Map<String, dynamic> json) {
    return TicketGraph(
      totalTickets: json['totalTickets'] ?? 0,
      allTickets: (json['allTickets'] as List<dynamic>?)
              ?.map((e) => Ticket.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalTickets': totalTickets,
      'allTickets': allTickets.map((e) => e.toJson()).toList(),
    };
  }
}

class Ticket {
  final String label;
  final int manualSupport;

  Ticket({
    required this.label,
    required this.manualSupport,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      label: json['label'] ?? '',
      manualSupport: json['manualSupport'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'manualSupport': manualSupport,
    };
  }
}
