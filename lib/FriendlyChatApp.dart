import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_friendlychat/screens/chat_screen.dart';

final googleSignIn = new GoogleSignIn();
final analytics = new FirebaseAnalytics();
final auth = FirebaseAuth.instance;
final reference = FirebaseDatabase.instance.reference().child('messages');
final storageReference = FirebaseStorage.instance.ref();

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
        analytics: analytics,
        auth: auth,
        reference: reference,
        storageReference: storageReference,
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
