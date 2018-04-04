import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:my_friendlychat/screens/ChatScreen.dart';

class FriendlyChatApp extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Friendly Chat",
      theme: defaultTargetPlatform == TargetPlatform.iOS
      ? kIosTheme
      : kDefaultTheme,
      home: new ChatScreen(),
    );
  }
}

final ThemeData kIosTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400]
);
