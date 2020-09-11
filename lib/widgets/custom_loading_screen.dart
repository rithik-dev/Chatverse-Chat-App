import 'package:chatverse_chat_app/providers/loading_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class CustomLoadingScreen extends StatelessWidget {
  final Widget child;

  CustomLoadingScreen({@required this.child});

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: Provider.of<LoadingScreenProvider>(context).isLoading,
      progressIndicator: CustomLoader(),
      child: this.child,
    );
  }
}

class CustomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitChasingDots(
        color: Colors.blue,
      ),
    );
  }
}
