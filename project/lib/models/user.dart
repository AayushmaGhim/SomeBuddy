import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;
  final String sentiment;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
    required this.sentiment,
  });


  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      sentiment: snapshot['sentiment'],
    );
  }

    Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "email": email,
    'photoUrl': photoUrl,
    "bio": bio,
    "followers": followers,
    "following": followers,
    "sentiment": sentiment,
  };

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] ?? '',
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photo'],
      bio: map['bio'],
      followers: map['followers'],
      following: map['following'],
      sentiment: map['sentiment'],
    );
  }
}