import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/feed_screen.dart';
import 'package:project/screens/private_post_screen.dart';
import 'package:project/screens/search_screen.dart';

import '../screens/add_post_screen.dart';
import '../screens/chat_home_screen.dart';
import '../screens/profile_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const ChatHomeScreen(),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
  const PrivatePostScreen(),
];
