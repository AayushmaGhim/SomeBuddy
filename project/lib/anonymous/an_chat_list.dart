import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project/anonymous/an_chat_controller.dart';
import 'package:project/anonymous/an_message.dart';
//import 'package:project/chat/controller/chat_controller.dart';
import 'package:project/widgets/loader.dart';
import 'package:project/widgets/sender_message_card.dart';

//import '../models/message.dart';
import '../widgets/my_message_card.dart';
//import 'my_message_card.dart';

class AnChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  const AnChatList(this.recieverUserId, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnChatListState();
}

class _AnChatListState extends ConsumerState<AnChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AnMessage>>(
      stream: ref.read(anChatControllerProvider).anChatStream(widget.recieverUserId),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Loader();
        }

        SchedulerBinding.instance.addPostFrameCallback((_) { 
messageController.jumpTo(messageController.position.maxScrollExtent);
        });

        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            var timeSent = DateFormat.Hm().format(messageData.timeSent);

            if(!messageData.isSeen && messageData.recieverId == FirebaseAuth.instance.currentUser!.uid){
              ref.read(anChatControllerProvider).setChatMessageSeen(context, widget.recieverUserId
              , messageData.AnMessageId);
            }
            if (messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: messageData.text,
                date: timeSent,
                isSeen: messageData.isSeen
              );
            }
            return SenderMessageCard(
              message: messageData.text,
              date: timeSent,
            );
          },
        );
      }
    );
  }
}

