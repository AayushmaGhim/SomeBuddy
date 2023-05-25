import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/message.dart';
//import 'package:project/utils/utils.dart';
import 'package:project/models/user.dart' as model;
//import 'package:project/utils/utils.dart';
import 'package:uuid/uuid.dart';
import '../../models/chat_contact.dart';
import '../../providers/message_enum.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ChatRepository({required FirebaseFirestore firestore, required FirebaseAuth auth});

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = model.User.fromMap(userData.data()!);

        contacts.add(
          ChatContact(
            name: user.username,
            profilePic: user.photoUrl,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  

  Stream<List<Message>> getChatStream(String recieverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }


  void _saveDataToContactsSubcollection({
    required String senderUserId,
    //required user.User recieverUserData,
    required String text,
    required DateTime timeSent,
    required String recieverUserId,
  }) async {
// users -> reciever user id => chats -> current user id -> set data
    try {
      var senderSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(senderUserId)
          .get();
      var recieverSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(recieverUserId)
          .get();
      var recieverChatContact = ChatContact(
        name: senderSnap['username'],
        profilePic: senderSnap['photoUrl'],
        contactId: senderSnap['uid'],
        timeSent: timeSent,
        lastMessage: text,
      );
      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .set(
            recieverChatContact.toJson(),
          );
      // users -> current user id  => chats -> reciever user id -> set data
      var senderChatContact = ChatContact(
        name: recieverSnap['username'],
        profilePic: recieverSnap['photoUrl'],
        contactId: recieverSnap['uid'],
        timeSent: timeSent,
        lastMessage: text,
      );
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .set(
            senderChatContact.toJson(),
          );
    } on Exception catch (err) {
      // TODO
      print('Err1 ${err.toString()}');
    }
  }

  void _saveMessageToMessageSubcollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required messageType,
    required String messageId,
    //required username,
    required recieverUserName,
    required senderUsername,
  }) async {
    try {
      final message = Message(
        type: messageType,
        senderId: auth.currentUser!.uid,
        recieverId: recieverUserId,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false,
      );

      // _firestore.collection('posts').doc(postId).set(
      //         post.toJson(),
      //       );

      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .set(
            message.toJson(),
          );

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .set(
            message.toJson(),
          );
    } on Exception catch (er) {
      // TODO
      print('Err2 ${er.toString()}');
    }
  }

  void sendTextMessage({
    required String text,
    required String recieverUserId,
    required String senderUserId,
  }) async {
    try {
      var timeSent = DateTime.now();

      var senderSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(senderUserId)
          .get();
      var recieverSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(recieverUserId)
          .get();
      // user.User? recieverUserData;
      // user.User? senderUserData;

      // var userDataMap =
      //     await firestore.collection('users').doc(recieverUserId).get();

      // var senderDataMap =
      //     await firestore.collection('users').doc(senderUserId).get();

      //recieverUserData = user.User.fromMap(userDataMap.data()!);
      //senderUserData = user.User.fromMap(senderDataMap.data()!);

      var messageId = const Uuid().v1();
      _saveDataToContactsSubcollection(
        senderUserId: senderUserId,
        //recieverUserData : recieverUserData,
        text: text,
        timeSent: timeSent,
        recieverUserId: recieverUserId,
      );

      _saveMessageToMessageSubcollection(
          recieverUserId: recieverUserId,
          text: text,
          timeSent: timeSent,
          messageType: MessageEnum.text,
          messageId: messageId,
          //username: senderSnap['username'],
          recieverUserName: recieverSnap['username'],
          senderUsername: senderSnap['username']);
    } on Exception catch (e) {
      // TODO
      print('Err3 ${e.toString()}');
    }
  }

   void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      print('Err4 ${e.toString()}');
    }
  }
}

