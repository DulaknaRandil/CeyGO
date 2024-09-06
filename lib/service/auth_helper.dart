import 'package:cey_go/ui/Navigation%20Bar/navigation_Bar.dart';
import 'package:cey_go/ui/Slide%20Screen/slide_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return NavigationBarScreen();
          } else {
            return SlideScreen();
          }
        },
      ),
    );
  }
}
