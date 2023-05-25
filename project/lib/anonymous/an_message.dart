// ignore_for_file: public_member_api_docs, sort_constructors_first
//import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class AnMessage {
  final String senderId;
  final String recieverId;
  final String text;
  final DateTime timeSent;
  final String AnMessageId;
  final bool isSeen;

  AnMessage({
    required this.senderId,
    required this.recieverId,
    required this.text,
    required this.timeSent,
    required this.AnMessageId,
    required this.isSeen,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'recieverId': recieverId,
      'text': text,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'AnMessageId': AnMessageId,
      'isSeen': isSeen,
    };
  }

  factory AnMessage.fromMap(Map<String, dynamic> map) {
    return AnMessage(
      senderId: map['senderId'] as String,
      recieverId: map['recieverId'] as String,
      text: map['text'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      AnMessageId: map['AnMessageId'] as String,
      isSeen: map['isSeen'] as bool,
    );
  }

static AnMessage fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return AnMessage(
      senderId: snapshot['senderId'],
      recieverId: snapshot['recieverId'],
      text: snapshot['text'],
      timeSent: snapshot['timeSent'],
      AnMessageId: snapshot['AnMessageId'],
      isSeen: snapshot['isSeen'],
    );
  }

    Map<String, dynamic> toJson() => {
    'senderId': senderId,
      'recieverId': recieverId,
      'text': text,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'AnMessageId': AnMessageId,
      'isSeen': isSeen,
  };
  
}
