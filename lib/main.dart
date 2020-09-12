import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/providers/drawer_provider.dart';
import 'package:chatverse_chat_app/providers/loading_screen_provider.dart';
import 'package:chatverse_chat_app/services/firebase_core_service.dart';
import 'package:chatverse_chat_app/utilities/route_generator.dart';
import 'package:chatverse_chat_app/utilities/theme_handler.dart';
import 'package:chatverse_chat_app/views/splash_screen.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO: make favorite contacts list view
// TODO: add like message feature
// TODO: add feature to drag and drop a person to the fav contacts list
// TODO: show green dot is user is online
// TODO: add option to send images/videos
// TODO: add favorite contacts button functionality
// TODO: add read more button for extremely long messages
// TODO: long tap on message to delete message?
// TODO: notifications when new message??
// TODO: handle cannot add contacts exception

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseCoreService.initApp();
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
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RouteGenerator.generateRoute,
            initialRoute: SplashScreen.id,
          );
        },
      ),
    );
  }
}
