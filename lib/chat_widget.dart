import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  final List<String> messages;

  const ChatWidget({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(messages[index]),
        );
      },
    );
  }
}
