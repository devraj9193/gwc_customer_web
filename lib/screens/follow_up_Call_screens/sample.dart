import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../widgets/constants.dart';

class EmojiFeedbackExample extends StatefulWidget {
  const EmojiFeedbackExample({Key? key}) : super(key: key);

  @override
  _EmojiFeedbackExampleState createState() => _EmojiFeedbackExampleState();
}

class _EmojiFeedbackExampleState extends State<EmojiFeedbackExample> {
  int selectedEmojiIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emoji Feedback Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'How was your experience?',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            EmojiFeedback(
              rating: 5,
              enableFeedback: true,
              elementSize: 50, spaceBetweenItems: 0,
              inactiveElementBlendColor: Colors.transparent,
              labelTextStyle: TextStyle(
                fontSize: 12.dp,
                fontFamily: kFontBook,
                color: gWhiteColor,
              ),
              onChanged: (index) {
                setState(() {
                  selectedEmojiIndex = index!;
                });
                print('Selected Emoji Index: $index');
              },
              // Customize the emojis
              emojiPreset: const [
                EmojiModel(src: '😡', label: ""),
                EmojiModel(src: '😕', label: ""),
                EmojiModel(src: '😐', label: ""),
                EmojiModel(src: '😊', label: ""),
                EmojiModel(src: '😍', label: ""),

              ],
            ),
            SizedBox(height: 30),
            if (selectedEmojiIndex != -1)
              Text(
                'You selected: ${selectedEmojiIndex + 1}',
                style: TextStyle(fontSize: 18, color: Colors.blueAccent),
              ),
          ],
        ),
      ),
    );
  }
}
