//import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:project/chat/controller/auth_controller.dart';
import 'package:project/chat/repository/chat_repository.dart';
import 'package:project/models/chat_contact.dart';
import 'package:project/models/message.dart';

// final chatControllerProvider = Provider((ref) {
//   final chatRepository = ref.watch(chatRepositoryProvider);
//   return ChatController(
//     chatRepository: chatRepository,
//     ref: ref,
//   );
// });

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
   ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContacts(){
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> chatStream(String recieverUserId){
    return chatRepository.getChatStream(recieverUserId);
  }

  void setChatMessageSeen(BuildContext context,
    String recieverUserId,
    String messageId,){
      chatRepository.setChatMessageSeen(context, recieverUserId, messageId);
    
  }
}
