import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_friendlychat/widgets/ChatMessage.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({this.googleSignIn, this.analytics, this.auth, this.reference});

  final GoogleSignIn googleSignIn;
  final FirebaseAnalytics analytics;
  final FirebaseAuth auth;
  final DatabaseReference reference;

  @override
  State<StatefulWidget> createState() => new ChatScreenState(
        googleSignIn: googleSignIn,
        analytics: analytics,
        auth: auth,
        reference: reference,
      );
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState(
      {this.googleSignIn, this.analytics, this.auth, this.reference});

  final GoogleSignIn googleSignIn;
  final FirebaseAnalytics analytics;
  final FirebaseAuth auth;
  final DatabaseReference reference;
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  Future<Null> _handleSubmitted(String text) async {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    await _ensureLoggedIn();
    _sendMessage(text: text);
  }

  void _sendMessage({String text}) {
    reference.push().set({
      'text': text,
      'senderName': googleSignIn.currentUser.displayName,
      'senderPhotoUrl': googleSignIn.currentUser.photoUrl,
    });
    analytics.logEvent(name: 'send_message');
  }

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) user = await googleSignIn.signInSilently();
    if (user == null) {
      await googleSignIn.signIn();
      analytics.logLogin();
    }

    if (await auth.currentUser() == null) {
      GoogleSignInAuthentication credentials =
          await googleSignIn.currentUser.authentication;
      await auth.signInWithGoogle(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken,
      );
    }
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = _textController.text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? new CupertinoButton(
                      child: new Text("Send"),
                      onPressed: _isComposing
                          ? () => _handleSubmitted(_textController.text)
                          : null)
                  : new IconButton(
                      icon: new Icon(Icons.send),
                      onPressed: _isComposing
                          ? () => _handleSubmitted(_textController.text)
                          : null),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Friendly Chat"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Flexible(
              child: new FirebaseAnimatedList(
                query: reference,
                sort: (a, b) => b.key.compareTo(a.key),
                padding: new EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder:
                    (_, DataSnapshot snapshot, Animation<double> animation) {
                  return new ChatMessage(
                    snapshot: snapshot,
                    animation: animation,
                  );
                },
              ),
            ),
            new Divider(height: 1.0),
            new Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? new BoxDecoration(
                border:
                    new Border(top: new BorderSide(color: Colors.grey[200])),
              )
            : null,
      ),
    );
  }
}
