import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:project/chat/screen/chat_screen.dart';

import '../utils/colors.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  
  bool isShowUsers = false;
  //DocumentSnapshot snap = FirebaseFirestore.instance.collection('users').doc().get();
  //     List following = (snap.data() as dynamic)['following'];
      
        //static String? uid;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        foregroundColor: primaryColor,
        title: Text('Anonymously text other users'),
        centerTitle: false,
      ),

      body:  FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users').where('sentiment' == ['sentiment'])
                  .get(),
              builder: (context, snapshot) {
                 if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }


                return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MobileChatScreen(
                              name: (snapshot.data! as dynamic).docs[index]
                                    ['username'], uid: (snapshot.data! as dynamic).docs[index]
                                    ['uid']
                            ),
                          ),),
                        
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                (snapshot.data! as dynamic).docs[index]
                                    ['photoUrl']),
                          ),
                          title: Text(
                            (snapshot.data! as dynamic).docs[index]['username'],
                          ),
                        ),
                      );
                    });
              
  })
    );

    
    

  }
}
