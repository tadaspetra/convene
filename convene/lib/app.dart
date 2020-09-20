import 'package:authentication_repository/authentication_repository.dart';
import 'package:convene/screens/email_not_verified/email_not_verified.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'screens/error/error.dart';
import 'screens/home/home.dart';
import 'screens/login/view/view.dart';
import 'screens/splash/splash.dart';

class App extends StatelessWidget {
  // Create the initilization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  void _navigateToRoute(Route route) {
    _navigator.pushAndRemoveUntil<void>(
      route,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            // Firebase check for errors
            if (snapshot.hasError) {
              _navigateToRoute(ErrorPage.route());
            }

            // Firebase initialized
            if (snapshot.connectionState == ConnectionState.done) {
              // Listen to user authentication state updates
              return ProviderListener(
                provider: authStateProvider,
                onChange: (AuthenticationState state) {
                  state.maybeWhen(
                    authenticated: (user) {
                      _navigateToRoute(HomePage.route());
                    },
                    emailNotVerified: () {
                      _navigateToRoute(EmailNotVerifiedPage.route());
                    },
                    unauthenticated: () {
                      _navigateToRoute(LoginPage.route());
                    },
                    error: (err) {
                      _navigateToRoute(ErrorPage.route());
                    },
                    orElse: () {},
                  );
                },
                child: child,
              );
            }

            // Firebase loading
            return child;
          },
        );
      },
      onGenerateRoute: (_) => MaterialPageRoute<SplashPage>(builder: (context) {
        return const SplashPage();
      }),
    );
  }
}
