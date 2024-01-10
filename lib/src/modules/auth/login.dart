import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../services/auth_services.dart';
import '../../services/helpers.dart';
import '../../widgets/appbar/appbar_custom.dart';
import '../../widgets/button/button_custom.dart';
import '../../widgets/text_field/text_field_custom.dart';
import 'sign_up.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  bool _submitted = false;
  Widget _buttonChild = const Text(
    'Log In',
    style: TextStyle(color: Colors.white),
  );

  @override
  void initState() {
    super.initState();
    _submitted = false;
  }

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarCustom(
        context: context,
        onPressed: () {
          Navigator.pop(context);
        },
        actions: [
          IconButton(
            icon: isDarkTheme(context)
                ? const Icon(CupertinoIcons.moon_fill)
                : const Icon(CupertinoIcons.sun_max_fill),
            color: getColorByBackground(context),
            onPressed: () => selectThemeMode(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 30.0),
              child: Text(
                "Log in with email",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFieldCustom(
                controller: emailController,
                icon: const Icon(CupertinoIcons.at),
                labelText: 'Email',
                errorText: _submitted == true && emailController.text.isEmpty
                    ? "Input can't be empty"
                    : _submitted == true && !validateEmail(emailController)
                        ? "Please enter the correct email"
                        : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: TextFieldCustom(
                controller: passwordController,
                icon: const Icon(CupertinoIcons.padlock),
                labelText: 'Password',
                isPassword: true,
                errorText: _submitted == true && passwordController.text.isEmpty
                    ? "Input can't be empty"
                    : null,
              ),
            ),
            buttonCustom(
              child: _buttonChild,
              onPressed: () async {
                setState(() => _submitted = true);
                setState(() => _buttonChild = const CircularProgressIndicator(
                      color: Colors.white,
                    ));

                if (_validateEmptyField() && validateEmail(emailController)) {
                  // if validation success
                  final result = await AuthService().signIn(
                    emailController.text,
                    passwordController.text,
                  );

                  print("Log In: ${result.toString()}");

                  if (result != null && result == false) {
                    Fluttertoast.showToast(
                        msg: "Could not sign in with credentials");
                    setState(() => _buttonChild = const Text(
                          'Log In',
                          style: TextStyle(color: Colors.white),
                        ));
                  } else {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                    // Fluttertoast.showToast(msg: "Welcome :)");
                    setState(() => _buttonChild = const Text(
                          'Log In',
                          style: TextStyle(color: Colors.white),
                        ));
                  }
                }

                setState(() => _buttonChild = const Text(
                      'Log In',
                      style: TextStyle(color: Colors.white),
                    ));
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SignUp()),
                );
              },
              child: const Text.rich(
                TextSpan(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(color: CustomColor.neutral2),
                    ),
                    TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(color: CustomColor.secondary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateEmptyField() {
    return emailController.text.isEmpty || passwordController.text.isEmpty
        ? false
        : true;
  }
}
