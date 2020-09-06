import 'package:flutter/material.dart';

class MyTextFormField extends StatefulWidget {
  final String labelText;
  final Function(String) onChanged;
  final String defaultValue;
  final bool autofocus;
  final TextEditingController controller;
  final Function(String) validator;
  final bool isPasswordField;
  final IconData icon;

  @override
  _MyTextFormFieldState createState() => _MyTextFormFieldState();

  const MyTextFormField({
    @required this.labelText,
    this.onChanged,
    @required this.icon,
    this.defaultValue,
    this.autofocus = false,
    this.controller,
    this.validator,
    this.isPasswordField = false,
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
      textAlign: TextAlign.center,
      autofocus: this.widget.autofocus,
      keyboardType: keyboardTypes[this.widget.labelText] ?? TextInputType.text,
      obscureText: this.widget.isPasswordField ? !_showPassword : false,
      decoration: InputDecoration(
        suffixIcon: this.widget.isPasswordField
            ? Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: IconButton(
                  splashRadius: 1.0,
                  icon: _showPassword
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                  iconSize: 30.0,
                  onPressed: this.toggleShowPassword,
                ),
              )
            : null,
        prefixIcon: Icon(
          this.widget.icon,
          color: Colors.grey,
        ),
        labelText: this.widget.labelText,
        labelStyle: TextStyle(color: Colors.black87),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }
}
