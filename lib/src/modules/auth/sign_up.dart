import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../services/auth_services.dart';
import '../../services/helpers.dart';
import '../../widgets/appbar/appbar_custom.dart';
import '../../widgets/button/button_custom.dart';
import '../../widgets/text_field/text_field_custom.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _submitted = false;
  Widget _buttonChild = const Text(
    'Register Now',
    style: TextStyle(color: Colors.white),
  );

  @override
  void initState() {
    super.initState();
    _submitted = false;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 30.0),
                      child: Text(
                        "Sign up with email",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextFieldCustom(
                        controller: nameController,
                        icon: const Icon(CupertinoIcons.person),
                        labelText: 'Enter Name',
                        errorText:
                            _submitted == true && nameController.text.isEmpty
                                ? "Input can't be empty"
                                : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFieldCustom(
                        controller: emailController,
                        icon: const Icon(CupertinoIcons.at),
                        labelText: 'Enter Email',
                        errorText:
                            _submitted == true && emailController.text.isEmpty
                                ? "Input can't be empty"
                                : _submitted == true &&
                                        !validateEmail(emailController)
                                    ? "Please enter the correct email"
                                    : null,
                      ),
                    ),
                    Divider(
                      color: getColorByBackground(context),
                      indent: 10,
                      endIndent: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: TextFieldCustom(
                        controller: passwordController,
                        icon: const Icon(CupertinoIcons.padlock),
                        labelText: 'Enter Password',
                        isPassword: true,
                        errorText: _submitted == true &&
                                passwordController.text.isEmpty
                            ? "Input can't be empty"
                            : _submitted == true &&
                                    !validatePassword(passwordController)
                                ? 'Password has to be more than 8 character. Minimum 1 upper case, lower case, number and special character.'
                                : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextFieldCustom(
                        controller: confirmPasswordController,
                        icon: const Icon(CupertinoIcons.padlock),
                        labelText: 'Confirm Password',
                        isPassword: true,
                        errorText: _submitted == true &&
                                confirmPasswordController.text.isEmpty
                            ? "Input can't be empty"
                            : !_validateConfirmPassword()
                                ? "Password and Confirm Password should have the same value"
                                : null,
                      ),
                    ),
                    buttonCustom(
                      child: _buttonChild,
                      onPressed: () async {
                        setState(() => _submitted = true);
                        setState(() =>
                            _buttonChild = const CircularProgressIndicator(
                              color: Colors.white,
                            ));

                        if (_validateEmptyField() &&
                            validateEmail(emailController) &&
                            validatePassword(passwordController) &&
                            _validateConfirmPassword()) {
                          // if validation success

                          try {
                            final result = await AuthService().signUp(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                            );

                            print("Result: $result");

                            if (result == null) {
                              setState(() => _buttonChild = const Text(
                                    "Register Now",
                                    style: TextStyle(color: Colors.white),
                                  ));
                            } else {
                              setState(() => _buttonChild = const Text(
                                    "Register Now",
                                    style: TextStyle(color: Colors.white),
                                  ));

                              final signOut = AuthService().signOut(result);
                              print("Sign Out: ${signOut.toString()}");

                              if (context.mounted) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Please log in first before continue.");
                                Navigator.pop(context);
                              }
                            }
                          } catch (e) {
                            print(e.toString());
                            Fluttertoast.showToast(msg: e.toString());
                          }
                        } else {
                          setState(() => _buttonChild = const Text(
                                "Register Now",
                                style: TextStyle(color: Colors.white),
                              ));
                        }
                      },
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const LogIn()),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      style: TextStyle(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(color: CustomColor.neutral2),
                        ),
                        TextSpan(
                          text: 'Log In',
                          style: TextStyle(color: CustomColor.secondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validateEmptyField() {
    return nameController.text.isEmpty ||
            emailController.text.isEmpty ||
            passwordController.text.isEmpty ||
            confirmPasswordController.text.isEmpty
        ? false
        : true;
  }

  bool _validateConfirmPassword() {
    return passwordController.text == confirmPasswordController.text
        ? true
        : false;
  }
}
