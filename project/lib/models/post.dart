import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';

class Post {
  final String description;
  final String uid;
  final String postId;
  final String username;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;
  final bool isPrivate;

  const Post({
    required this.description,
    required this.uid,
    required this.postId,
    required this.username,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
    required this.isPrivate,
  });


  static Post fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      description: snapshot['description'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
      postUrl: snapshot['postUrl'],
      isPrivate: snapshot['isPrivate'],
    );
  }

    Map<String, dynamic> toJson() => {
    "description": description,
    "uid": uid,
    "username": username,
    "postId": postId,
    "datePublished": datePublished,
    'profImage': profImage,
    "likes": likes,
    'postUrl': postUrl,
    "isPrivate": isPrivate,
  };
}