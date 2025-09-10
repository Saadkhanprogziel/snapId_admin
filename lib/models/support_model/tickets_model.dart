class TicketsData {
  final List<TicketDetails> tickets;
  final Pagination pagination;

  TicketsData({
    required this.tickets,
    required this.pagination,
  });

  factory TicketsData.fromJson(Map<String, dynamic> json) {
    return TicketsData(
      tickets: (json['tickets'] as List<dynamic>)
          .map((item) => TicketDetails.fromJson(item))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tickets': tickets.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class TicketDetails {
  final String id;
  final String title;
  final String description;
  final String status;
  final DateTime createdAt;
  final User user;

  TicketDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.user,
  });

  factory TicketDetails.fromJson(Map<String, dynamic> json) {
    return TicketDetails(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'user': user.toJson(),
    };
  }
}

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }
}

class Pagination {
  final int totalTickets;
  final int currentPage;
  final int totalPages;

  Pagination({
    required this.totalTickets,
    required this.currentPage,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalTickets: json['totalTIckets'], // Note: server key has "TIckets"
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalTIckets': totalTickets,
      'currentPage': currentPage,
      'totalPages': totalPages,
    };
  }
}
