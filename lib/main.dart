import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:instant_gram/state/auth/providers/auth_state_provider.dart';
import 'package:instant_gram/state/auth/providers/is_logged_in_provider.dart';
import 'package:instant_gram/state/providers/is_loading_provider.dart';
import 'package:instant_gram/state/views/components/constants/loading/loading_screen.dart';


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
            indicatorColor: Colors.blueGrey),
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.teal,
        ),
        themeMode: ThemeMode.dark,
        home: Consumer(
          builder: (_, ref, child) {
            ref.listen<bool>(isLoadingProvider, (_, isLoading) {
              if (isLoading) {
                LoadingScreen.instance().show(context: context,text: 'loading');
              } else {
                LoadingScreen.instance().hide();
              }
            });
            final isLoggedIn = ref.watch(isLoggedInProvider);
            if (isLoggedIn) {
              return const MainView();
            } else {
              return const LogginView();
            }
          },
        ));
  }
}

class MainView extends ConsumerWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Main View'),
        ),
        body: TextButton(
          onPressed: () async {
            LoadingScreen.instance().show(context: context, text: 'welcome');
            ref.read(authStateProvider.notifier).logOut();
          },
          child: const Text('loggout'),
        ));
  }
}

class LogginView extends ConsumerWidget {
  const LogginView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loggin View'),
      ),
      body: Column(children: [
        TextButton(
          onPressed: ref.read(authStateProvider.notifier).loginWithGoogle,
          child: const Text('google'),
        ),
        TextButton(
          onPressed: ref.read(authStateProvider.notifier).loginWithFacebook,
          child: const Text('facebook'),
        ),
      ]),
    );
  }
}


// Variant: debugAndroidTest
// Config: debug
// Store: C:\Users\user\.android\debug.keystore
// Alias: AndroidDebugKey
// MD5: EF:38:92:25:E0:C2:7E:61:2F:09:C0:E2:52:18:C0:AC
// SHA1: 4F:A5:FB:3C:66:22:72:13:A5:1B:D5:8E:73:95:09:86:4B:82:5D:08
// SHA-256: 13:55:52:C7:53:AE:07:A8:59:7F:72:8A:FA:78:1E:A1:28:31:A8:5B:91:8C:42:B3:25:A1:3A:96:91:E5:5A:C6
// Valid until: Monday, January 13, 2053

