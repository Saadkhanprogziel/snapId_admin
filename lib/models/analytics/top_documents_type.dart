class TopDocumentTypesResponse {
  final List<TopDocumentType> topDocumentTypes;
  final int totalTopDocumentType;

  TopDocumentTypesResponse({
    required this.topDocumentTypes,
    required this.totalTopDocumentType,
  });

  factory TopDocumentTypesResponse.fromJson(Map<String, dynamic> json) {
    return TopDocumentTypesResponse(
      topDocumentTypes: (json['topDocumentTypes'] as List<dynamic>)
          .map((e) => TopDocumentType.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalTopDocumentType: json['totalTopDocumentType'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topDocumentTypes': topDocumentTypes.map((e) => e.toJson()).toList(),
      'totalTopDocumentType': totalTopDocumentType,
    };
  }
}

class TopDocumentType {
  final String country;
  final String documentType;
  final int count;

  TopDocumentType({
    required this.country,
    required this.documentType,
    required this.count,
  });

  factory TopDocumentType.fromJson(Map<String, dynamic> json) {
    return TopDocumentType(
      country: json['country'] as String,
      documentType: json['documentType'] as String,
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'documentType': documentType,
      'count': count,
    };
  }
}
