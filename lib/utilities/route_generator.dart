import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/models/message.dart';
import 'package:chatverse_chat_app/views/add_attachment_screen.dart';
import 'package:chatverse_chat_app/views/authentication_screen.dart';
import 'package:chatverse_chat_app/views/chat_screen.dart';
import 'package:chatverse_chat_app/views/full_screen_media_view_page.dart';
import 'package:chatverse_chat_app/views/home_screen.dart';
import 'package:chatverse_chat_app/views/intro_screen.dart';
import 'package:chatverse_chat_app/views/profile_screen.dart';
import 'package:chatverse_chat_app/views/search_contacts_screen.dart';
import 'package:chatverse_chat_app/views/settings_screen.dart';
import 'package:chatverse_chat_app/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    print("PUSHING SCREEN : ${settings.name}");
    switch (settings.name) {
      case AddAttachment.id:
        return PageTransition(
            type: PageTransitionType.downToUp,
            child: AddAttachment(
              contact: (args as Map)['contact'] as Contact,
              profilePicHeroTag: (args as Map)['profilePicHeroTag'] as String,
            ));
      case FullScreenMediaViewPage.id:
        return PageTransition(
          type: PageTransitionType.scale,
          child: FullScreenMediaViewPage(
            url: (args as Map)['mediaUrl'] as String,
            messageType: (args as Map)['messageType'] as MessageType,
            senderName: (args as Map)['senderName'] as String,
          ),
        );
      case SearchContactsScreen.id:
        return PageTransition(
            type: PageTransitionType.downToUp, child: SearchContactsScreen());
      case SettingsScreen.id:
        return PageTransition(
            type: PageTransitionType.scale, child: SettingsScreen());
      case ProfileScreen.id:
        return PageTransition(
            type: PageTransitionType.scale, child: ProfileScreen());
      case ChatScreen.id:
        return PageTransition(
          type: PageTransitionType.leftToRightWithFade,
          child: ChatScreen(
            contact: (args as Map)['contact'] as Contact,
            profilePicHeroTag: (args as Map)['profilePicHeroTag'] as String,
          ),
        );
      case HomeScreen.id:
        return PageTransition(
            type: PageTransitionType.leftToRightWithFade, child: HomeScreen());
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
