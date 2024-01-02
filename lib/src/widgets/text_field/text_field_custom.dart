import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldCustom extends StatefulWidget {
  const TextFieldCustom({
    super.key,
    required this.icon,
    required this.labelText,
    this.isPassword = false,
    this.controller,
    this.errorText,
  });

  final Icon icon;
  final String labelText;
  final bool isPassword;
  final TextEditingController? controller;
  final String? errorText;

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  // Initially password is obscure
  bool _obscureText = true;
  Icon _peek = const Icon(CupertinoIcons.eye);

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
      _peek = _obscureText
          ? const Icon(CupertinoIcons.eye)
          : const Icon(CupertinoIcons.eye_fill);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isPassword
        ? Material(
            elevation: 2,
            borderOnForeground: false,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                errorText: widget.errorText,
                errorMaxLines: 2,
                prefixIcon: widget.icon,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                labelText: widget.labelText,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                suffixIcon: IconButton(
                  icon: _peek,
                  onPressed: _toggle,
                ),
              ),
              obscureText: _obscureText,
              enableSuggestions: false,
              autocorrect: false,
            ),
          )
        : Material(
            elevation: 2,
            borderOnForeground: false,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                prefixIcon: widget.icon,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                errorText: widget.errorText,
                errorMaxLines: 2,
                labelText: widget.labelText,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                // fillColor: Colors.transparent,
                // filled: true,
              ),
            ),
          );
  }
}
