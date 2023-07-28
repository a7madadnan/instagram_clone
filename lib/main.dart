import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:instant_gram/state/auth/providers/auth_state_provider.dart';
import 'package:instant_gram/state/auth/providers/is_logged_in_provider.dart';
import 'package:instant_gram/state/providers/is_loading_provider.dart';
import 'package:instant_gram/views/components/loading/loading_screen.dart';
import 'package:instant_gram/views/login/login_view.dart';

import 'firebase_options.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(
    child: App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blueGrey,
          indicatorColor: Colors.blueGrey,
        ),
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.teal,
        ),
        themeMode: ThemeMode.dark,
        home: Consumer(
          builder: (context, ref, child) {
            ref.listen<bool>(isLoadingProvider, (_, isLoading) {
              if (isLoading) {
                LoadingScreen.instance()
                    .show(context: context, text: 'loading');
              } else {
                LoadingScreen.instance().hide();
              }
            });
            final isLoggedIn = ref.watch(isLoggedInProvider);
            if (isLoggedIn) {
              return const MainView();
            } else {
              return const LoginView();
            }
          },
        ));
  }
}

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Main View'),
        ),
        body: Consumer(builder: (context, ref, child) {
          return TextButton(
            onPressed: () async {
              ref.read(authStateProvider.notifier).logOut();
            },
            child: const Text('loggout'),
          );
        }));
  }
}
