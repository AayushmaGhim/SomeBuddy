// import 'dart:io';
// import 'package:flutter/material.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:provider/provider.dart';

import '../../resources/auth_methods.dart';
import 'package:project/models/user.dart' as model;

// final authControllerProvider = Provider(create: (ref) {
//   final authRepository = ref.watch(authRepositoryProvider);
//   return AuthController(authRepository: authRepository, ref: ref);
// });

// final userDataAuthProvider = FutureProvider(initialData: (ref) {
//   final authController = ref.watch(authControllerProvider);
//   return authController.getUserData();
// });

class AuthController {
  final AuthRepository authRepository;
  //final ProviderRef ref;
  AuthController({
    required this.authRepository,
    //required this.ref,
  });

  Future<model.User?> getUserData() async {
    model.User? user = await authRepository.getCurrentUserData();
    return user;
  }

 

  // void saveUserDataToFirebase(
  //     BuildContext context, String name, File? profilePic) {
  //   authRepository.saveUserDataToFirebase(
  //     name: name,
  //     profilePic: profilePic,
  //     ref: ref,
  //     context: context,
  //   );
  // }

  Stream<model.User> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}