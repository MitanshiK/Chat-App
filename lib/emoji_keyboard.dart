import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class EmojiKeyboard extends StatefulWidget {
  @override
  EmojiKeyboardState createState() => EmojiKeyboardState();
}

class EmojiKeyboardState extends State<EmojiKeyboard> {
late  bool isShowSticker;

  @override
  void initState() {
    super.initState();
    isShowSticker = false;
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // your list goes here
                
                  // Input content
                  buildInput(),
                
                  // Sticker
                  (isShowSticker ? buildSticker() : Container()),
                ],
              ),
            ],
          ),
        ),
        
      ),
    );
  }

  Widget buildInput() {
    return Container(
      width: double.infinity,
  height: 50.0,
  decoration: const BoxDecoration(
      border: Border(
          top: BorderSide(color: Colors.blueGrey, width: 0.5)),
      color: Colors.white),
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: const Icon(Icons.image),
                onPressed: () {},
                color: Colors.blueGrey,
              ),
            ),
          ),
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: const Icon(Icons.face),
                onPressed: () {
                  setState(() {
                    isShowSticker = !isShowSticker;
                  });
                },
                color: Colors.blueGrey,
              ),
            ),
          ),

          // Edit text
          const Flexible(
            child:  TextField(
              style: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
                        decoration: InputDecoration.collapsed(
            hintText: 'Type your message...',
            hintStyle: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
      ),

      // Button send message
      Material(
        color: Colors.white,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {},
            color: Colors.blueGrey,
          ),
        ),
      ),
    ],
  ),
    );
  }

  Widget buildSticker() {
    return EmojiPicker(
   
  onEmojiSelected: (emoji, category) {
    print(emoji);
  },
    );
  }
}