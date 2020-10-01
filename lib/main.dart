import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/providers/chatscreen_appbar_provider.dart';
import 'package:chatverse_chat_app/providers/drawer_provider.dart';
import 'package:chatverse_chat_app/providers/homescreen_appbar_provider.dart';
import 'package:chatverse_chat_app/providers/loading_screen_provider.dart';
import 'package:chatverse_chat_app/services/firebase_core_service.dart';
import 'package:chatverse_chat_app/services/push_notification_service.dart';
import 'package:chatverse_chat_app/utilities/route_generator.dart';
import 'package:chatverse_chat_app/utilities/theme_handler.dart';
import 'package:chatverse_chat_app/views/splash_screen.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO: add last seen / online in chat screen
//TODO: add cloud function to clear deleted messages everyday??
//TODO: add block option
// TODO: add like message feature
// TODO: add feature to drag and drop a person to the fav contacts list
// TODO: show green dot is user is online
// TODO: add read more button for extremely long messages
// TODO: notifications when new message??
//TODO: add emoji keyboard
//TODO : use about dialog to show version and other stuff (AboutDialog widget)
//TODO:add last message timestamp in firebase and sort messages using it in recent chats
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseCoreService.initApp();
  await PushNotificationsService.initFirebaseMessaging();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(
          create: (_) => User.fromNullValues(),
        ),
        ChangeNotifierProvider<LoadingScreenProvider>(
          create: (_) => LoadingScreenProvider(),
        ),
        ChangeNotifierProvider<HomeScreenAppBarProvider>(
          create: (_) => HomeScreenAppBarProvider(),
        ),
        ChangeNotifierProvider<ChatScreenAppBarProvider>(
          create: (_) => ChatScreenAppBarProvider(),
        ),
        Provider<DrawerProvider>(
          create: (_) => DrawerProvider(),
        ),
      ],
      child: DynamicTheme(
        defaultBrightness: ThemeHandler.defaultBrightness,
        data: ThemeHandler.getThemeData,
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            theme: theme,
            darkTheme: ThemeHandler.darkTheme,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RouteGenerator.generateRoute,
            initialRoute: SplashScreen.id,
          );
        },
      ),
    );
  }
}
