import 'package:admin/models/support_model/message.dart';
import 'package:dartz/dartz.dart';

import '../../network/network_repository.dart';

class ChatRepository {
  final networkRepository = NetworkRepository();

  Future<Either<String, List<ChatMessage>>> fetchAllMessages({
    required int limit,
    required String chatId,
  }) async {
    final response =
        await networkRepository.get(url: "/chat/$chatId/get-all-messages", extraQuery: {
      "limit": limit,
    });

    if (!response.failed) {
              final List<dynamic> messages = response.data['data'];

       List<ChatMessage> data =
            messages.map((item) => ChatMessage.fromJson(item)).toList();
      return right(data);
    }

    return left(response.message);
  }

}
