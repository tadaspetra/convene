import 'package:convene/config/palette.dart';
import 'package:convene/config/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_repository/user_repository.dart';

import 'pages/email_not_verified/email_not_verified.dart';
import 'pages/error/error.dart';
import 'pages/home/home.dart';
import 'pages/login/login_page.dart';
import 'pages/splash/splash.dart';

class App extends StatefulWidget {
  // Create the initilization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Future<FirebaseApp> _initialization;

  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  void _navigateToRoute(String route) {
    _navigator.pushNamedAndRemoveUntil<void>(
      route,
      (_) => false,
    );
  }

  @override
  void initState() {
    // TODO provide better debug settup
    // The .then will use the local Firebase Emulator
    _initialization = Firebase.initializeApp()
      ..then((value) {
        // final host = Platform.isAndroid ? '10.0.2.2:8080' : 'localhost:8080';
        // FirebaseFirestore.instance.settings = Settings(
        //   host: host,
        //   sslEnabled: false,
        // );
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme().buildTheme(),
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            // Firebase check for errors
            if (snapshot.hasError) {
              _navigateToRoute("error");
            }

            // Firebase initialized
            if (snapshot.connectionState == ConnectionState.done) {
              //context.read(authRepositoryProvider).logOut();
              // Listen to user authentication state updates
              return ProviderListener(
                onChange: (AuthenticationState value) {
                  value.when(authenticated: (user) {
                    _navigateToRoute("/home");
                  }, emailNotVerified: () {
                    _navigateToRoute("/emailnotverified");
                  }, error: (Object error) {
                    _navigateToRoute("/error");
                  }, loading: () {
                    _navigateToRoute("/loading");
                  }, unauthenticated: () {
                    _navigateToRoute("/login");
                  });
                },
                provider: authStateProvider,
                child: child,
              );
            }

            // Firebase loading
            return child;
          },
        );
      },
      onGenerateRoute: (settings) {
        //final arguments = settings.arguments;
        switch (settings.name) {
          case "/home":
            return MaterialPageRoute<HomePage>(
              builder: (context) => const HomePage(),
            );
            break;
          case "/login":
            return MaterialPageRoute<HomePage>(
              builder: (context) => const LoginPage(),
            );
            break;
          case "/loading":
            return MaterialPageRoute<HomePage>(
              builder: (context) => const SplashPage(),
            );
            break;
          case "/error":
            return MaterialPageRoute<HomePage>(
              builder: (context) => const ErrorPage(),
            );
            break;
          case "/emailnotverified":
            return MaterialPageRoute<HomePage>(
              builder: (context) => const EmailNotVerifiedPage(),
            );
            break;
          default:
            return MaterialPageRoute<SplashPage>(
              builder: (context) => const SplashPage(),
            );
            break;
        }
      },
      initialRoute: "/login",
    );
  }
}
