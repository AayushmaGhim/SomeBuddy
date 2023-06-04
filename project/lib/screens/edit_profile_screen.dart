import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:provider/provider.dart';

//import '../models/user.dart';
//import '../providers/user_provider.dart';
import '../resources/storage_methods.dart';
import '../utils/colors.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import '../widgets/text_field_input.dart';

class EditProfile extends StatefulWidget {
  final String uid;
  const EditProfile({super.key, required this.uid});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Uint8List? _image;
  var userData = {};
  bool _isLoading = false;

  String? get uid => widget.uid;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  getData() async {
    setState(() {});
    setState(() {
      _isLoading = true;
    });
    try {
      // var userSnap = await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(widget.uid)
      //     .get();

      User currentUser = _auth.currentUser!;
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      userData = userSnap.data()!;
      setState(() {});
    } catch (err) {
      print(err.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  editUser() {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_image != null) {
        Future<String> photoUrl = StorageMethods()
            .uploadImageToStorage('profilePics', _image!, false);

        //   > userData = {
        //        'username': _usernameController.text,
        //     'bio': _bioController.text,
        //     'photoUrl': photoUrl,
        // };

        //   await userData.update({
        //     'username': _usernameController.text,
        //     'bio': _bioController.text,
        //     'photoUrl': photoUrl,
        // });

        userData['photoUrl'] = photoUrl;
        setState(() {
          _isLoading = false;
        });
      }
      if (_usernameController.text.isNotEmpty) {
        //String? username;
        _firestore
            .collection('users')
            .doc(uid)
            .update({'username': _usernameController.text});
        //userData.update('username', (value) => _usernameController.text);
        setState(() {
          _isLoading = false;
        });
        return showSnackBar('Updated Successfully', context);
      }
      if (_bioController.text.isNotEmpty) {
        String? bio;
        _firestore
            .collection('users')
            .doc(uid)
            .update({'bio': _bioController.text});
        setState(() {
          //userData['bio'] = _bioController.text;
          _isLoading = false;
        });
        return showSnackBar('Updated Successfully', context);
      }
      if (_image == null &&
          _bioController.text.isEmpty &&
          _usernameController.text.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return showSnackBar('Please enter at least one feild', context);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      return showSnackBar(e.toString(), context);
    }
    //userData.update(key, (value) => null)
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference userRef = _firestore.collection('users').doc('uid');

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              foregroundColor: primaryColor,
              title: const Text(
                'Edit Your Profile',
                style: TextStyle(color: primaryColor),
              ),
              centerTitle: false,
            ),
            body: SafeArea(
                child: Container(
              padding: MediaQuery.of(context).size.width > webScreenSize
                  ? EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 3)
                  : const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: Container(), flex: 2),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: userData['username'],
                          //text: 'username',
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  //image selector
                  Stack(children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(userData['photoUrl']),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                        ),
                      ),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  //username changer
                  TextFieldInput(
                    hintText: 'Enter new username',
                    textInputType: TextInputType.text,
                    textEditingController: _usernameController,
                  ),
                  const SizedBox(height: 24),

                  TextFieldInput(
                    hintText: 'Enter new bio',
                    textInputType: TextInputType.text,
                    textEditingController: _bioController,
                  ),
                  const SizedBox(height: 24),

                  InkWell(
                    onTap: editUser,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          color: blueColor),
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: secondaryColor,
                              ),
                            )
                          : const Text(
                              'Make Changes',
                              style: TextStyle(color: secondaryColor),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: secondaryColor),
                      ),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          color: blueColor),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Flexible(child: Container(), flex: 2),
                ],
              ),
            )));
  }
}
