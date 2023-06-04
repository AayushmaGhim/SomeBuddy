import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project/utils/global_variables.dart';

import '../anonymous/an_chat_home_screen.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  int postLen1 = 0;
  late PageController pageController;

  void initState(){
    super.initState();
    getData();
    pageController = PageController();
  }

  @override
  void dispose(){
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  } 

  getData() async{
      var postSnap1 = await FirebaseFirestore.instance
          .collection('posts').where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen1 = postSnap1.docs.length;
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Image.asset('assets/images/SomeBuddy.png',
          height: 50,
        ),
        actions: [
          IconButton(
            onPressed: () => navigationTapped(0),
            icon: Icon(
              Icons.home,
              color: _page == 0 ? selectedIconColor: primaryColor,
            ),
          ),
          IconButton(
            onPressed: () => navigationTapped(1),
            icon: Icon(
              Icons.search,
              color: _page == 1 ? selectedIconColor: primaryColor,
            ),
          ),IconButton(
            onPressed: () => navigationTapped(2),
            icon: Icon(
              Icons.add_circle,
              color: _page == 2 ? selectedIconColor: primaryColor,
            ),
          ),
          IconButton(
            onPressed: () => navigationTapped(3),
            icon: Icon(
              Icons.message,
              color: _page == 3 ? selectedIconColor: primaryColor,
            ),
          ),
          IconButton(
            onPressed: () => navigationTapped(4),
            icon: Icon(
              Icons.person,
              color: _page == 4 ? selectedIconColor: primaryColor,
            ),
          ),
          IconButton(
            onPressed: () => navigationTapped(5),
            icon: Icon(
              Icons.lock,
              color: _page == 5 ? selectedIconColor: primaryColor,
            ),
          ),
          IconButton(
            onPressed: () {if(postLen1 > 0){Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AnChatHomeScreen()));} else{return showSnackBar('Upload at least one post to send anonymous texts', context);}},
            icon: Icon(
              Icons.question_answer,
              color: _page == 6 ? selectedIconColor: primaryColor,
            ),
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
    );
  }
} 