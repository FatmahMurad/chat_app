import 'package:chat/app/core/extensions/context.extensions.dart';
import 'package:chat/app/modules/auth/domain/helper/auth_helper.dart';
import 'package:chat/app/modules/auth/domain/providers/state/auth_providers.dart';
import 'package:chat/app/modules/auth/widgets/my_textform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyAuthForm extends ConsumerStatefulWidget {
  const MyAuthForm({
    super.key,
    this.registerFormKey,
  });

  final GlobalKey<FormState>? registerFormKey;

  @override
  ConsumerState createState() => _MyAuthFormState();
}

class _MyAuthFormState extends ConsumerState<MyAuthForm> {
  final authValidators = AuthValidators();

  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  final TextEditingController userNameController = TextEditingController();
  final FocusNode userNameFocus = FocusNode();

  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    emailFocusNode.dispose();

    passwordController.dispose();
    passwordFocusNode.dispose();

    userNameController.dispose();
    userNameFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authFormContrller = ref.watch(authFormController);
    return SizedBox(
      child: Form(
        key: widget.registerFormKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              MyTextFormWidget(
                controller: emailController,
                obscureText: false,
                focusNode: emailFocusNode,
                validator: (input) {
                  return authValidators.emailValidator(input);
                },
                prefIcon: const Icon(Icons.email),
                labelText: context.translate.email,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  if (value != null) {
                    authFormContrller.setEmailField(value);
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              MyTextFormWidget(
                controller: userNameController,
                obscureText: false,
                focusNode: userNameFocus,
                validator: (input) => authValidators.userNameValidator(input),
                prefIcon: const Icon(Icons.person),
                labelText: context.translate.userName,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  if (value != null) {
                    authFormContrller.setUserNameField(value);
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              MyTextFormWidget(
                controller: passwordController,
                obscureText:
                    authFormContrller.togglePassword == false ? true : false,
                focusNode: passwordFocusNode,
                validator: (input) => authValidators.passwordVlidator(input),
                prefIcon: const Icon(Icons.password),
                labelText: context.translate.password,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  if (value != null) {
                    authFormContrller.setPasswordField(value);
                  }
                  return null;
                },
                togglePassword: () {
                  authFormContrller.togglePasswordIcon();
                },
                suffexIcon: Icon(
                  authFormContrller.togglePassword
                      ? Icons.remove_red_eye_outlined
                      : Icons.remove_red_eye_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
