import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final String uid;
  const EditProfile({super.key, required this.uid});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}