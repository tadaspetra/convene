import 'dart:developer';

import 'package:convene/config/palette.dart';

import 'package:convene/domain/navigation/navigation_state.dart';
import 'package:convene/pages/add_book/add_book.dart';
import 'package:convene/pages/create_club/create_club.dart';
import 'package:convene/pages/finished_book/finished_book.dart';
import 'package:convene/pages/join_club/join_club.dart';
import 'package:convene/providers/navigation_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/logger.dart';
import 'pages/email_not_verified/email_not_verified.dart';
import 'pages/error/error.dart';
import 'pages/home/home.dart';
import 'pages/login/view/login_page.dart';
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

  void _navigateToRoute(Route route) {
    _navigator.pushAndRemoveUntil<void>(
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
              //context.read(authRepositoryProvider).logOut();
              // Listen to user authentication state updates
              return ProviderListener(
                provider: navigationProvider,
                onChange: (NavigationState state) {
                  state.when(
                    home: () => _navigateToRoute(HomePage.route),
                    addBook: () => _navigateToRoute(AddBookPage.route),
                    finishedBook: () => _navigateToRoute(FinishedBookPage.route),
                    createClub: () => _navigateToRoute(CreateClubPage.route),
                    joinClub: () => _navigateToRoute(JoinClubPage.route),
                    unauthenticated: () => _navigateToRoute(LoginPage.route),
                    emailNotVerified: () => _navigateToRoute(EmailNotVerifiedPage.route),
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
