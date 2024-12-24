import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    String welcomeMessage = 'Bienvenido a App EDE';

    if (authState is AuthAuthenticated) {
      welcomeMessage = 'Bienvenido, token: ${authState.token}';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(welcomeMessage),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(LoggedOut());
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
