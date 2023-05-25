import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/responsive/mobile_screen_layout.dart';
import 'package:project/responsive/responsive_layout_screen.dart';
import 'package:project/responsive/web_screen_layout.dart';
import 'package:project/screens/login_screen.dart';
import 'package:project/screens/signup_screen.dart';
import 'package:provider/provider.dart' as prov;

import 'utils/colors.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyC4JrtGHj4Bb3vo8O2xgwonRpGUBTM5fGU',
        appId: '1:1095120958767:web:af00b3536b558467b51dda',
        messagingSenderId: '1095120958767',
        projectId: 'production-project-224a6',
        storageBucket: "production-project-224a6.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  //runApp(const MyApp());
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return prov.MultiProvider(
      providers: [
        prov.ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'someBuddy',
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
              ));
            }

            return const LoginScreen();
          }),
        ),
      ),
    );
  }
}
