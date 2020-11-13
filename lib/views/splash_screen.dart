import 'package:chatverse_chat_app/controllers/user_controller.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/utilities/shared_preferences.dart';
import 'package:chatverse_chat_app/views/authentication_screen.dart';
import 'package:chatverse_chat_app/views/home_screen.dart';
import 'package:chatverse_chat_app/views/intro_screen.dart';
import 'package:chatverse_chat_app/widgets/custom_loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static const id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> getData() async {
    await SharedPrefs.initialize();
    final Map<String, dynamic> localData = await SharedPrefs.getData();
    print("localData : $localData");
    if (localData['seenIntro']) {
      if (localData['userId'] == null)
        Navigator.pushReplacementNamed(context, AuthenticationPage.id);
      else {
        final User user = await UserController.getUser(localData['userId']);
        Provider.of<User>(context, listen: false).updateUserInProvider(user);
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      }
    } else {
      await SharedPrefs.setSeenIntro(true);
      Navigator.pushReplacementNamed(context, IntroScreen.id);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomLoader(),
    );
  }
}
