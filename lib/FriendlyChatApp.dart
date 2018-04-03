import 'package:flutter/material.dart';
import 'package:my_friendlychat/screens/ChatScreen.dart';

class FriendlyChatApp extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Friendly Chat",
      home: new ChatScreen(),
    );
  }
}
