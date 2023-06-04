import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/post.dart';
import 'package:project/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';
import 'package:dart_sentiment/dart_sentiment.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload posts
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "Some error occured";

    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
        isPrivate: false,
      );

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );

      predictSentiment(description, uid);
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('Comment is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //delete post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setPostAsPrivate(String postId) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .update({'isPrivate': true});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setPostAsPublic(String postId) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .update({'isPrivate': false});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> predictSentiment(String description, String uid) async {
      Sentiment sentiment = Sentiment();
      final res = await sentiment.analysis(description);
      //String result = res['score'].toString();
       
      if(res['score'] > 0){
        await _firestore
          .collection('users')
          .doc(uid)
          .update({'sentiment': '1'});
      }
      else{
        await _firestore
          .collection('users')
          .doc(uid)
          .update({'sentiment': '0'});
      } 
}

  //follow users
  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data() as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(followId).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(followId).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
