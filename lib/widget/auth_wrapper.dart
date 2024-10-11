import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raporti_veturave_app/providers/user_provider.dart';
import 'package:raporti_veturave_app/screens/home_screen.dart';
import 'package:raporti_veturave_app/screens/login.dart';

class AuthWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProvider);

    return userAsyncValue.when(
      data: (user) {
        if (user == null) {
          return LoginScreen();
        } else {
          return const HomeScreen();
        }
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}
