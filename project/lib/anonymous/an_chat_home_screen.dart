import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/anonymous/an_chat_screen.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:project/chat/screen/chat_screen.dart';
import 'package:project/models/user.dart' as model;
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../utils/colors.dart';

class AnChatHomeScreen extends StatefulWidget {
  const AnChatHomeScreen({super.key});

  @override
  State<AnChatHomeScreen> createState() => _AnChatHomeScreenState();
}

class _AnChatHomeScreenState extends State<AnChatHomeScreen> {
  
  bool isShowUsers = false;
  //DocumentSnapshot snap = FirebaseFirestore.instance.collection('users').doc().get();
  //     List following = (snap.data() as dynamic)['following'];
      
        //static String? uid;

  @override
  void dispose() {
    super.dispose();
  }
  


      // var userDataMap =
      //     await firestore.collection('users').doc(recieverUserId).get()

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        foregroundColor: primaryColor,
        title: const Text('Anonymously text other users'),
        centerTitle: false,
      ),

      body:  FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users').where('sentiment' , isEqualTo : user.sentiment)
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
                            builder: (context) => AnMobileChatScreen(
                              name: (snapshot.data! as dynamic).docs[index]
                                    ['username'], uid: (snapshot.data! as dynamic).docs[index]
                                    ['uid']
                            ),
                          ),),
                        
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                          'https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/626fd8140423801.6241b91e24d9c.png',)),
                          title: Text(
                            'Anonymous',
                          ),
                        ),
                      );
                    });
              
  })
    );

    
    

  }
}
