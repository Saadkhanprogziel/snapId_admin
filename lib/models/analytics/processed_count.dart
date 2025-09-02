class ProcessingRequestResponse {
  final bool success;
  final String message;
  final ProcessedDocCountModel data;

  ProcessingRequestResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProcessingRequestResponse.fromJson(Map<String, dynamic> json) {
    return ProcessingRequestResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: ProcessedDocCountModel.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class ProcessedDocCountModel {
  final int totalSessions;
  final DocumentByStatus sessionByStatus;

  ProcessedDocCountModel({
    required this.totalSessions,
    required this.sessionByStatus,
  });

  factory ProcessedDocCountModel.fromJson(Map<String, dynamic> json) {
    return ProcessedDocCountModel(
      totalSessions: json['totalSessions'] as int,
      sessionByStatus: DocumentByStatus.fromJson(json['sessionByStatus']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalSessions': totalSessions,
      'sessionByStatus': sessionByStatus.toJson(),
    };
  }
}

class DocumentByStatus {
  final int imageProcessed;
  final int downloaded;

  DocumentByStatus({
    required this.imageProcessed,
    required this.downloaded,
  });

  factory DocumentByStatus.fromJson(Map<String, dynamic> json) {
    return DocumentByStatus(
      imageProcessed: json['image_processed'] as int,
      downloaded: json['downloaded'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_processed': imageProcessed,
      'downloaded': downloaded,
    };
  }
}
