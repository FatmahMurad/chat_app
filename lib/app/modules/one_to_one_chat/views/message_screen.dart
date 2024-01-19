import 'package:chat/app/modules/chats/domain/models/user_model.dart';
import 'package:chat/app/modules/one_to_one_chat/views/chat_view.dart';
import 'package:flutter/material.dart';

class OneToOneMessagingScreen extends StatelessWidget {
  final UserModel user;

  const OneToOneMessagingScreen({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.username.toString()),
      ),
      body: MessagingBodyView(selectedUser: user),
    );
  }
}
