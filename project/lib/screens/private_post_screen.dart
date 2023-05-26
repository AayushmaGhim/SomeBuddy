import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project/anonymous/an_chat_home_screen.dart';
import 'package:project/utils/colors.dart';
import 'package:project/utils/utils.dart';
import 'package:project/widgets/post_card.dart';

import '../widgets/private_post_card.dart';

class PrivatePostScreen extends StatefulWidget {
  const PrivatePostScreen({super.key});

  @override
  State<PrivatePostScreen> createState() => _PrivatePostScreenState();
}

class _PrivatePostScreenState extends State<PrivatePostScreen> {
  int postLen = 0;
  @override
  void initState() {
    getData();
  }

  getData() async {
    var postSnap = await FirebaseFirestore.instance
        .collection('posts')
        .get();

    postLen = postSnap.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        foregroundColor: primaryColor,
        title: const Text('Your Posts'),
        centerTitle: false,
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
            itemBuilder: (context, index) => PrivatePostCard(
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),
    );
  }
}
