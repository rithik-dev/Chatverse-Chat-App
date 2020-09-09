import 'package:chatverse_chat_app/views/authentication_screen.dart';
import 'package:chatverse_chat_app/views/chat_screen.dart';
import 'package:chatverse_chat_app/views/home_screen.dart';
import 'package:chatverse_chat_app/views/intro_screen.dart';
import 'package:chatverse_chat_app/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    print("PUSHING SCREEN : ${settings.name}");
    switch (settings.name) {
      case ChatScreen.id:
        return PageTransition(
            type: PageTransitionType.fade, child: ChatScreen(friend: args));
      case HomeScreen.id:
        return PageTransition(
            type: PageTransitionType.fade, child: HomeScreen());
      case AuthenticationPage.id:
        return PageTransition(
            type: PageTransitionType.fade, child: AuthenticationPage());
      case IntroScreen.id:
        return PageTransition(
            type: PageTransitionType.fade, child: IntroScreen());
      case SplashScreen.id:
        return PageTransition(
            type: PageTransitionType.fade, child: SplashScreen());
      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String route) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('$route not found...'),
        ),
      );
    });
  }
}
