import 'package:chat/app/config/theme/my_colors.dart';
import 'package:chat/app/core/extensions/context.extensions.dart';
import 'package:chat/app/modules/auth/widgets/my_authform.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.translate.register,
          style: context.theme.textTheme.titleMedium?.copyWith(
            color: MyColors.white,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyAuthForm(registerFormKey: formKey),
          const SizedBox(
            height: 12,
          ),
          ElevatedButton(
              onPressed: () {}, child: Text(context.translate.register)),
          const SizedBox(
            height: 12,
          ),
          TextButton(
              onPressed: () {}, child: Text(context.translate.googleLogin)),
        ],
      ),
    );
  }
}
