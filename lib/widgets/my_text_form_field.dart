import 'package:chatverse_chat_app/utilities/theme_handler.dart';
import 'package:flutter/material.dart';

class MyTextFormField extends StatefulWidget {
  final String labelText;
  final Function(String) onChanged;
  final String defaultValue;
  final bool autofocus;
  final TextEditingController controller;
  final Function(String) validator;
  final bool isPasswordField;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final bool showPrefixIcon;
  final bool showSuffixIcon;
  final VoidCallback suffixIconOnPressed;

  @override
  _MyTextFormFieldState createState() => _MyTextFormFieldState();

  const MyTextFormField({
    @required this.labelText,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.defaultValue,
    this.autofocus = false,
    this.controller,
    this.validator,
    this.suffixIconOnPressed,
    this.isPasswordField = false,
    this.showPrefixIcon = true,
    this.showSuffixIcon = false,
  });
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  final Map<String, TextInputType> keyboardTypes = {
    'Email': TextInputType.emailAddress,
    'Password': TextInputType.visiblePassword,
    'Phone': TextInputType.phone,
  };

  bool _showPassword = false;

  void toggleShowPassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.widget.controller,
      initialValue: this.widget.defaultValue,
      validator: this.widget.validator,
      onChanged: this.widget.onChanged,
      textAlign: TextAlign.start,
      autofocus: this.widget.autofocus,
      keyboardType: keyboardTypes[this.widget.labelText] ?? TextInputType.text,
      obscureText: this.widget.isPasswordField ? !_showPassword : false,
      decoration: InputDecoration(
        hintStyle:
            Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black),
        suffixIcon: this.widget.showSuffixIcon
            ? this.widget.isPasswordField
                ? IconButton(
                    icon: _showPassword
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    iconSize: 30.0,
                    color: Colors.deepOrangeAccent,
                    onPressed: this.toggleShowPassword,
                  )
                : IconButton(
          icon: Icon(this.widget.suffixIcon),
          onPressed: this.widget.suffixIconOnPressed,
          color: Colors.deepOrangeAccent,
        )
            : null,
        prefixIcon: this.widget.showPrefixIcon
            ? Icon(
          this.widget.prefixIcon,
          color: Colors.deepOrangeAccent,
        )
            : null,
        labelText: this.widget.labelText,
        labelStyle: TextStyle(color: ThemeHandler.primaryColor(context)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
      style: TextStyle(color: ThemeHandler.primaryColor(context)),
    );
  }
}
