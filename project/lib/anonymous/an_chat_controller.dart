//import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/anonymous/an_chat_contact.dart';
import 'package:project/anonymous/an_chat_repository.dart';
import 'package:project/anonymous/an_message.dart';
// //import 'package:project/chat/controller/auth_controller.dart';
// import 'package:project/chat/repository/chat_repository.dart';
// import 'package:project/models/chat_contact.dart';
// import 'package:project/models/message.dart';

// final chatControllerProvider = Provider((ref) {
//   final chatRepository = ref.watch(chatRepositoryProvider);
//   return ChatController(
//     chatRepository: chatRepository,
//     ref: ref,
//   );
// });

final anChatControllerProvider = Provider((ref) {
  final anChatRepository = ref.watch(anChatRepositoryProvider);
  return AnChatController(
    anChatRepository: anChatRepository,
    ref: ref,
  );
});

class AnChatController {
   AnChatRepository anChatRepository;
  final ProviderRef ref;
  AnChatController({
    required this.anChatRepository,
    required this.ref,
  });

  Stream<List<AnChatContact>> anChatContacts(){
    return anChatRepository.getChatContacts();
  }

  Stream<List<AnMessage>> anChatStream(String recieverUserId){
    return anChatRepository.getChatStream(recieverUserId);
  }

  void setChatMessageSeen(BuildContext context,
    String recieverUserId,
    String messageId,){
      anChatRepository.setChatMessageSeen(context, recieverUserId, messageId);
    
  }
}
