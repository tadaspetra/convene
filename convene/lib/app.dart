import 'package:convene/config/palette.dart';
import 'package:convene/providers.dart';
import 'package:convene/screens/add_book/view/add_book_page.dart';
import 'package:convene/screens/email_not_verified/email_not_verified.dart';
import 'package:convene/screens/login/view/login_page.dart';
import 'package:convene/services/navigation/navigation_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'screens/error/error.dart';
import 'screens/home/home.dart';
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
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonColor: Palette.darkerGrey,
        canvasColor: Palette.lightGrey,
        accentColor: Palette.lightBlue,
        primaryColor: Palette.darkerGrey,
        buttonTheme: const ButtonThemeData(
          buttonColor: Palette.darkerGrey,
          textTheme: ButtonTextTheme.primary,
        ),
        colorScheme: const ColorScheme.light(
          primary: Colors.black, //flat button text color
        ),
      ),
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
                provider: navigationProvider,
                onChange: (NavigationState state) {
                  state.when(
                    home: () => _navigateToRoute(HomePage.route()),
                    addBook: () => _navigateToRoute(AddBookPage.route()),
                    unauthenticated: () => _navigateToRoute(LoginPage.route()),
                    emailNotVerified: () =>
                        _navigateToRoute(EmailNotVerifiedPage.route()),
                    loading: () => _navigateToRoute(SplashPage.route()),
                    error: (Object error) =>
                        _navigateToRoute(ErrorPage.route()),
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
