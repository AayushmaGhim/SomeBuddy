import 'package:flutter/material.dart';
import 'package:project/chat/widget/bottom_chat_field.dart';
import 'package:project/utils/colors.dart';

//import '../../info.dart';
import '../../widgets/chat_list.dart';
// import 'package:whatsapp_ui/colors.dart';
// import 'package:whatsapp_ui/info.dart';
// import 'package:whatsapp_ui/widgets/chat_list.dart';

class MobileChatScreen extends StatelessWidget {
  final String name;
  final String uid;
  const MobileChatScreen({Key? key, required this.name, required this.uid}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        foregroundColor: primaryColor,
        title: Text(
          name,
        ),
        centerTitle: false,
        
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList( uid),
          ),
          BottomChatField(recieverUserId: uid),
        ],
      ),
    );
  }
}

