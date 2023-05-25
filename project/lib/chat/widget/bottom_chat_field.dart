import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:project/chat/controller/chat_controller.dart';
// import 'package:project/models/user.dart' as model;
// import 'package:project/resources/auth_methods.dart';
// import 'package:provider/provider.dart';
// import '../../providers/user_provider.dart';
import '../../utils/colors.dart';
import '../repository/chat_repository.dart';

class BottomChatField extends StatefulWidget {
  final String recieverUserId;
  const BottomChatField({
    Key? key,
    required this.recieverUserId,
  }) : super(key: key);

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}


class _BottomChatFieldState extends State<BottomChatField> {

  
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  
  
  
  //ChatRepository chatRepository = ChatRepository(firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance);
 // AuthRepository authRepository= AuthRepository(auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance);
  
  //String? recieverUserId;

  // final model.User user = Provider.of<UserProvider>(context).getUser;

  

  // void sendTextMessage() async {
  //   //final model.User user1 = FirebaseAuth.instance.currentUser!;
  //   if (isShowSendButton) {
  //     chatRepository.sendTextMessage(
  //             context: context,
  //             text: _messageController.text,
  //             recieverUserId: recieverUserId,
  //             senderUser: getUserData());
  //         setState(() {
  //           _messageController.text = '';
  //         });
  //   }
  // }

  
  @override
  void dispose(){
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _messageController,
            onChanged: (val){
              if (val.isNotEmpty){
                setState(() {
                  isShowSendButton = true;
                });
              }
              else{
                setState(() {
                  isShowSendButton = false;
                });
              }
            },
            cursorColor: greyColor,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 216, 213, 213),
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Icon(
                  Icons.emoji_emotions,
                  color: Colors.grey,
                ),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              ),
              hintText: 'Type a message!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Padding( 
          padding: const EdgeInsets.only(
            bottom: 8,
            right: 2,
            left: 2,
          ),
          child: CircleAvatar(
            backgroundColor: selectedIconColor,
            radius: 25,
            child: GestureDetector(
              onTap: () {
                ChatRepository(auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance).sendTextMessage(
              text: _messageController.text,
              recieverUserId: widget.recieverUserId,
              senderUserId: FirebaseAuth.instance.currentUser!.uid);
          setState(() {
            _messageController.text = '';
          });
              },
              child: Icon(
                isShowSendButton ? Icons.send : Icons.textsms,
                color: secondaryColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
