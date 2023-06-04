import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:project/anonymous/an_chat_home_screen.dart';
import 'package:project/utils/colors.dart';
import 'package:project/utils/global_variables.dart';
import 'package:project/utils/utils.dart';
import 'package:project/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  
    int postLen = 0;
    int postLen1 = 0;
@override
  void initState() {
    getData();
  }

  getData() async{
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .get();
      var postSnap1 = await FirebaseFirestore.instance
          .collection('posts').where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      postLen1 = postSnap1.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: width > webScreenSize ? null 
      : AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Image.asset('assets/images/SomeBuddy.png',
          height: 50,
        ),
        actions: [
          IconButton(
            onPressed: () {if(postLen1 > 0){Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AnChatHomeScreen()));} else{return showSnackBar('Upload at least one post to send anonymous texts', context);}},
            icon: const Icon(
              Icons.messenger,
              color: primaryColor,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > webScreenSize ? width*0.3 : 0,
                vertical: width > webScreenSize ? 15 : 0,
              ),
              child: PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        },
      ),
    );
  }
}
