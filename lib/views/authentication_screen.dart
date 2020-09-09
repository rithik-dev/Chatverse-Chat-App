import 'package:chatverse_chat_app/controllers/user_controller.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/providers/loading_screen_provider.dart';
import 'package:chatverse_chat_app/services/firebase_auth_service.dart';
import 'package:chatverse_chat_app/utilities/exceptions.dart';
import 'package:chatverse_chat_app/utilities/functions.dart';
import 'package:chatverse_chat_app/views/home_screen.dart';
import 'package:chatverse_chat_app/widgets/custom_loading_screen.dart';
import 'package:chatverse_chat_app/widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum authTab { signIn, signUp }

class AuthenticationPage extends StatefulWidget {
  static const id = 'authentication_page';
  final authTab authPage;

  AuthenticationPage({this.authPage = authTab.signIn});

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  List<Color> colors = [Color(0xFFFB9245), Color(0xFFF54E6B)];
  int _index;

  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  static LoadingScreenProvider loadingProvider;

  String _signInEmail;
  String _signInPassword;

  String _signUpName;
  String _signUpEmail;
  String _signUpPassword;

  final TextEditingController _signInEmailController = TextEditingController();
  final TextEditingController _signInPasswordController =
      TextEditingController();

  final TextEditingController _signUpNameController = TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();

    _signUpNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _index = widget.authPage == authTab.signIn ? 0 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    loadingProvider = Provider.of<LoadingScreenProvider>(context);

    return CustomLoadingScreen(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _tabs(context),
                  Builder(
                    builder: (context) {
                      return AnimatedCrossFade(
                        duration: Duration(milliseconds: 250),
                        firstChild: _signInTab(context),
                        secondChild: _signUpTab(context),
                        crossFadeState: _index == 0
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _emailNotVerifiedSnackBar(BuildContext context) {
    Functions.showSnackBar(
      context,
      "Please verify your email address !",
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: "RESEND LINK !",
        textColor: Colors.white,
        onPressed: () async {
          loadingProvider.startLoading();
          final bool success =
              await FirebaseAuthService.resendEmailVerificationLink(
            this._signInEmail,
            this._signInPassword,
          );
          if (success)
            Functions.showSnackBar(
                context, "Email verification link sent successfully !");
          else
            Functions.showSnackBar(context,
                "An error occurred while sending email verification link !");
          loadingProvider.stopLoading();
        },
      ),
    );
  }

  Widget _signInTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 15, right: 15),
      child: Column(
        children: <Widget>[
          Stack(
              overflow: Overflow.visible,
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, left: 15, right: 15, bottom: 20),
                    child: Form(
                      key: this._signInFormKey,
                      child: Column(
                        children: <Widget>[
                          MyTextFormField(
                            labelText: "Email",
                            controller: this._signInEmailController,
                            prefixIcon: Icons.email,
                            onChanged: (String email) {
                              this._signInEmail = email;
                            },
                            validator: (String value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim() == "")
                                return 'Please enter your email address';
                              else if (!(value.contains("@") &&
                                  value.contains(".")))
                                return "Please enter a valid email address";
                            },
                          ),
                          Divider(color: Colors.grey, height: 8),
                          MyTextFormField(
                            labelText: "Password",
                            showSuffixIcon: true,
                            isPasswordField: true,
                            controller: this._signInPasswordController,
                            prefixIcon: Icons.lock,
                            onChanged: (String password) {
                              this._signInPassword = password;
                            },
                            validator: (String value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim() == "")
                                return 'Please enter your password';
                              else if (value.length < 6)
                                return "Password should be at least 6 characters long";
                            },
                          ),
                          Divider(
                            color: Colors.transparent,
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -10,
                  child: _authenticationButton(
                      text: "SIGN IN",
                      onTap: () async {
                        if (this._signInFormKey.currentState.validate()) {
                          loadingProvider.startLoading();
                          try {
                            final User user = await UserController.signInUser(
                                this._signInEmail, this._signInPassword);
                            Provider.of<User>(context, listen: false)
                                .updateUserInProvider(user);
                            Navigator.pushReplacementNamed(
                                context, HomeScreen.id);
                          } on SignInException catch (e) {
                            if (e.message != null) {
                              if (e.message == "EMAIL_NOT_VERIFIED") {
                                this._emailNotVerifiedSnackBar(context);
                              } else
                                Functions.showSnackBar(context, e.message);
                            }
                          } catch (e) {
                            print("LOGIN EXCEPTION : ${e.toString()}");
                          }
                          loadingProvider.stopLoading();
                        }
                      }),
                ),
              ]),
          Padding(
            padding: const EdgeInsets.only(top: 45.0),
            child: GestureDetector(
              child: Text(
                "Forgot Password?",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () async {
                if (this._signInEmail == null || this._signInEmail.trim() == "")
                  Functions.showSnackBar(
                      context, "Please enter an email address");
                else if (!this._signInEmail.contains("@") ||
                    !this._signInEmail.contains((".")))
                  Functions.showSnackBar(
                      context, "Please enter a valid email address");
                else {
                  loadingProvider.startLoading();
                  try {
                    final bool success =
                    await FirebaseAuthService.sendPasswordResetEmail(
                      this._signInEmail,
                    );
                    if (success)
                      Functions.showSnackBar(
                          context, "Password reset email sent !");
                    else
                      Functions.showSnackBar(
                          context, "Error sending password reset email  !");
                  } on ForgotPasswordException catch (e) {
                    Functions.showSnackBar(context, e.message);
                  } catch (e) {
                    print("PASSWORD RESET EMAIL EXCEPTION : ${e.toString()}");
                  }
                  loadingProvider.stopLoading();
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 55,
                  height: 1,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    "OR",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 55,
                  height: 1,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _externalAuthCircularButton('assets/logo/google.png',
                    onTap: () {
                  print("sign in with google");
                }),
                SizedBox(width: 55),
                _externalAuthCircularButton('assets/logo/fb.png', onTap: () {
                  print("sign in with facebook");
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _signUpTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 15, right: 15),
      child: Column(
        children: <Widget>[
          Stack(
              overflow: Overflow.visible,
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, left: 15, right: 15, bottom: 20),
                    child: Form(
                      key: this._signUpFormKey,
                      child: Column(
                        children: <Widget>[
                          MyTextFormField(
                            labelText: "Name",
                            controller: this._signUpNameController,
                            prefixIcon: Icons.text_fields,
                            onChanged: (String name) {
                              this._signUpName = name;
                            },
                            validator: (String value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim() == "")
                                return "Please enter your name";
                            },
                          ),
                          Divider(color: Colors.grey, height: 8),
                          MyTextFormField(
                            labelText: "Email",
                            controller: this._signUpEmailController,
                            prefixIcon: Icons.email,
                            onChanged: (String email) {
                              this._signUpEmail = email;
                            },
                            validator: (String value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim() == "")
                                return 'Please enter your email address';
                              else if (!(value.contains("@") &&
                                  value.contains(".")))
                                return "Please enter a valid email address";
                            },
                          ),
                          Divider(color: Colors.grey, height: 8),
                          MyTextFormField(
                            labelText: "Password",
                            showSuffixIcon: true,
                            isPasswordField: true,
                            controller: this._signUpPasswordController,
                            prefixIcon: Icons.lock,
                            onChanged: (String password) {
                              this._signUpPassword = password;
                            },
                            validator: (String value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim() == "")
                                return 'Please enter your password';
                              else if (value.length < 6)
                                return "Password should be at least 6 characters long";
                            },
                          ),
                          Divider(
                            color: Colors.transparent,
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -10,
                  child: Center(
                    child: _authenticationButton(
                        text: "SIGN UP",
                        onTap: () async {
                          if (this._signUpFormKey.currentState.validate()) {
                            try {
                              loadingProvider.startLoading();
                              final bool success =
                              await UserController.signUpUser(
                                name: this._signUpName,
                                email: this._signUpEmail,
                                password: this._signUpPassword,
                              );

                              if (success) {
                                this._signUpNameController.clear();
                                this._signUpEmailController.clear();
                                this._signUpPasswordController.clear();

                                setState(() {
                                  _index = 0;
                                });

                                this._signInEmailController.text =
                                    this._signUpEmail;
                                this._signInPasswordController.text =
                                    this._signUpPassword;

                                this._signInEmail = this._signUpEmail;
                                this._signInPassword = this._signUpPassword;

                                Functions.showSnackBar(context,
                                    "Email verification link sent successfully");
                              }
                            } on SignUpException catch (e) {
                              Functions.showSnackBar(context, e.message);
                            } catch (e) {
                              print("REGISTER EXCEPTION : ${e.toString()}");
                            }
                            loadingProvider.stopLoading();
                          }
                        }),
                  ),
                ),
              ]),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 55,
                  height: 1,
                  color: Colors.white,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    "OR",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: 55,
                  height: 1,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _externalAuthCircularButton('assets/logo/google.png',
                    onTap: () {
                  print("sign up with google");
                }),
                SizedBox(width: 55),
                _externalAuthCircularButton('assets/logo/fb.png', onTap: () {
                  print("sign up with facebook");
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _externalAuthCircularButton(String imgUrl, {VoidCallback onTap}) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Image.asset(imgUrl),
        ),
      ),
      onTap: onTap,
    );
  }

  GestureDetector _authenticationButton(
      {@required String text, @required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabs(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30.0, left: 15, right: 15),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.12),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _tabItem(text: "Sign In", index: 0),
            _tabItem(text: "Sign Up", index: 1),
          ],
        ),
      ),
    );
  }

  Widget _tabItem({String text, int index}) {
    return Expanded(
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
              color: _index == index ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(25)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                text,
                style: TextStyle(
                  color: _index == index ? Colors.black : Colors.white,
                  fontSize: 18,
                  fontWeight:
                      _index == index ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
        onTap: () {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}
