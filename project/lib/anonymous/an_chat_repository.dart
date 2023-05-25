import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/anonymous/an_chat_contact.dart';
import 'package:project/anonymous/an_message.dart';
//import 'package:project/models/message.dart';
//import 'package:project/utils/utils.dart';
import 'package:project/models/user.dart' as model;
//import 'package:project/utils/utils.dart';
import 'package:uuid/uuid.dart';
//import '../../models/chat_contact.dart';
//import '../../providers/message_enum.dart';

final anChatRepositoryProvider = Provider(
  (ref) => AnChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class AnChatRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AnChatRepository({required FirebaseFirestore firestore, required FirebaseAuth auth});

  Stream<List<AnChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('anChats')
        .snapshots()
        .asyncMap((event) async {
      List<AnChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = AnChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = model.User.fromMap(userData.data()!);

        contacts.add(
          AnChatContact(
            name: 'anonymous',
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

  

  Stream<List<AnMessage>> getChatStream(String recieverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('anChats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<AnMessage> messages = [];
      for (var document in event.docs) {
        messages.add(AnMessage.fromMap(document.data()));
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
      var recieverChatContact = AnChatContact(
        name: 'anonymous',
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
      var senderChatContact = AnChatContact(
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
    //required messageType,
    required String messageId,
    //required username,
    required recieverUserName,
    required senderUsername,
  }) async {
    try {
      final message = AnMessage(
        //type: messageType,
        senderId: auth.currentUser!.uid,
        recieverId: recieverUserId,
        text: text,
        timeSent: timeSent,
        AnMessageId: messageId,
        isSeen: false,
      );

      // _firestore.collection('posts').doc(postId).set(
      //         post.toJson(),
      //       );

      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('anChats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .set(
            message.toJson(),
          );

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('anChats')
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
      // ;

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
          //messageType: MessageEnum.text,
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

