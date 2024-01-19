import 'package:chat/app/config/routes/named_routes.dart';
import 'package:chat/app/modules/auth/domain/providers/state/auth_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkIfAuth = ref.watch(checkIfAuthinticated);
    return Scaffold(
      body: checkIfAuth.when(data: (AsyncValue<User?> data) {
        if (data.value?.uid != null) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            context.goNamed(MyNamedRoutes.homePage);
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            context.goNamed(MyNamedRoutes.register);
          });
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }, error: (Object error, StackTrace stackTrace) {
        return Center(child: Text(error.toString()));
      }, loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
