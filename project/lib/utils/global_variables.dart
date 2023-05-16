import 'package:flutter/material.dart';
import 'package:project/screens/feed_screen.dart';

import '../screens/add_post_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  Text('search'),
  AddPostScreen(),
  Text('notif'),
  Text('profile'),
];
