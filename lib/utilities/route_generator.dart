import 'package:chatverse_chat_app/views/splash_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    print("PUSHING ID : ${settings.name}");
    switch (settings.name) {
      case SplashScreen.id:
        return MaterialPageRoute(builder: (_) => SplashScreen());
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
