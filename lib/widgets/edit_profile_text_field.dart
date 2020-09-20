import 'package:chatverse_chat_app/utilities/theme_handler.dart';
import 'package:flutter/material.dart';

class EditProfileTextField extends StatefulWidget {
  final IconData prefixIcon;
  final Function(String) onChanged;
  final VoidCallback onEditPressed;
  final String defaultValue;

  EditProfileTextField({
    @required this.prefixIcon,
    @required this.onChanged,
    @required this.onEditPressed,
    this.defaultValue = "",
  });

  @override
  _EditProfileTextFieldState createState() => _EditProfileTextFieldState();
}

class _EditProfileTextFieldState extends State<EditProfileTextField> {
  bool readOnly = true;

  void toggleReadOnly() {
    setState(() {
      readOnly = !readOnly;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: ThemeHandler.primaryColor(context).withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        readOnly: readOnly,
        textInputAction: TextInputAction.done,
        initialValue: this.widget.defaultValue,
        onChanged: this.widget.onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(20),
          border: InputBorder.none,
          prefixIcon: Icon(
            this.widget.prefixIcon,
            color: ThemeHandler.secondaryColor(context),
          ),
          suffixIcon: this.readOnly
              ? IconButton(
                  icon: Icon(Icons.edit),
                  color: ThemeHandler.secondaryColor(context),
                  onPressed: this.toggleReadOnly,
                )
              : IconButton(
                  icon: Icon(Icons.check),
                  color: ThemeHandler.secondaryColor(context),
                  onPressed: () {
                    this.toggleReadOnly();
                    return this.widget.onEditPressed();
                  },
                ),
        ),
        style: TextStyle(
          color: ThemeHandler.secondaryColor(context),
        ),
      ),
    );
  }
}
