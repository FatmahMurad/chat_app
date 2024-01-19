import 'package:chat/app/config/routes/named_routes.dart';
import 'package:chat/app/modules/chats/domain/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatUserCard extends StatelessWidget {
  const ChatUserCard({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(user.username.toString()),
        subtitle: Text(user.email.toString()),
        onTap: () {
          context.goNamed(MyNamedRoutes.chatDetails, extra: user);
        },
      ),
    );
  }
}
