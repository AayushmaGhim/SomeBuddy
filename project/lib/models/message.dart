// ignore_for_file: public_member_api_docs, sort_constructors_first
//import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/providers/message_enum.dart';

class Message {
  final String senderId;
  final String recieverId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;

  Message({
    required this.type, 
    required this.senderId,
    required this.recieverId,
    required this.text,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'recieverId': recieverId,
      'text': text,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      recieverId: map['recieverId'] as String,
      text: map['text'] as String,
      type: (map['type'] as String).toEnum(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      messageId: map['messageId'] as String,
      isSeen: map['isSeen'] as bool,
    );
  }

static Message fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return Message(
      senderId: snapshot['senderId'],
      recieverId: snapshot['recieverId'],
      text: snapshot['text'],
      type: snapshot['type'],
      timeSent: snapshot['timeSent'],
      messageId: snapshot['messageId'],
      isSeen: snapshot['isSeen'],
    );
  }

    Map<String, dynamic> toJson() => {
    'senderId': senderId,
      'recieverId': recieverId,
      'text': text,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
  };
  
}
