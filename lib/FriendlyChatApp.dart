import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_friendlychat/screens/chat_screen.dart';

final googleSignIn = new GoogleSignIn();

class FriendlyChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Friendly Chat",
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIosTheme
          : kDefaultTheme,
      home: new ChatScreen(
        googleSignIn: googleSignIn,
      ),
    );
  }
}

final ThemeData kIosTheme = new ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light);

final ThemeData kDefaultTheme =
    new ThemeData(primarySwatch: Colors.blue, accentColor: Colors.pinkAccent);
