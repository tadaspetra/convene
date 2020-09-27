import 'dart:developer';

import 'package:convene/config/palette.dart';

import 'package:convene/domain/navigation/navigation_state.dart';
import 'package:convene/pages/create_club/create_club.dart';
import 'package:convene/pages/finished_book/finished_book.dart';
import 'package:convene/pages/join_club/join_club.dart';
import 'package:convene/providers/navigation_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/add_book/add_book.dart';
import 'config/logger.dart';
import 'pages/email_not_verified/email_not_verified.dart';
import 'pages/error/error.dart';
import 'pages/home/home.dart';
import 'pages/login/view/login_page.dart';
import 'pages/splash/splash.dart';

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
              _navigateToRoute(ErrorPage.route);
            }

            // Firebase initialized
            if (snapshot.connectionState == ConnectionState.done) {
              // Listen to user authentication state updates
              return ProviderListener(
                provider: navigationProvider,
                onChange: (NavigationState state) {
                  state.when(
                    home: () => _navigateToRoute(HomePage.route),
                    addBook: () => _navigateToRoute(AddBookPage.route),
                    finishedBook: () =>
                        _navigateToRoute(FinishedBookPage.route),
                    createClub: () => _navigateToRoute(CreateClubPage.route),
                    joinClub: () => _navigateToRoute(JoinClubPage.route),
                    unauthenticated: () => _navigateToRoute(LoginPage.route),
                    emailNotVerified: () =>
                        _navigateToRoute(EmailNotVerifiedPage.route),
                    loading: () => _navigateToRoute(SplashPage.route),
                    error: (Object error) {
                      log(error.toString(), name: "Convene Log");
                      logger.e(error.toString());
                      _navigateToRoute(ErrorPage.route);
                    },
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
