import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../services/helpers.dart';
import '../../../widgets/appbar/appbar_confirm_cancel.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({
    super.key,
    this.includeAuth = true,
  });
  final bool includeAuth;

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _submitted = false;
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    oldPasswordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarConfirmCancel(
        title: "Update Password",
        onCancel: () => Navigator.pop(context),
        onConfirm: () async {
          // setState(() => _submitted = true);

          // print("newPasswordController: ${newPasswordController.text}");
          // print("oldPasswordController: ${oldPasswordController.text}");
          // print("emailController: ${emailController.text}");

          // if (widget.includeAuth) {
          //   if (_validateEmptyFieldWAuth() &&
          //       validateEmail(emailController) &&
          //       validatePassword(newPasswordController) &&
          //       _validateConfirmPassword() &&
          //       validatePassword(oldPasswordController)) {
          //     final result = await UserServices().updatePassword(
          //       user: widget.user,
          //       email: emailController.text,
          //       oldPassword: oldPasswordController.text,
          //       newPassword: newPasswordController.text,
          //       includeAuth: true,
          //     );

          //     if (result == true && context.mounted) {
          //       Fluttertoast.showToast(
          //           msg: "Password Updated. Please refresh to see changes.");
          //       Navigator.pop(context);
          //     }
          //   }
          // } else {
          //   if (_validateEmptyField() &&
          //       _validateConfirmPassword() &&
          //       validatePassword(newPasswordController)) {
          //     final result = await UserServices().updatePassword(
          //       user: widget.user,
          //       newPassword: newPasswordController.text,
          //       includeAuth: false,
          //     );

          //     if (result == true && context.mounted) {
          //       Fluttertoast.showToast(
          //           msg: "Password Updated. Please refresh to see changes.");
          //       Navigator.pop(context);
          //     }
          //   }
          // }
        },
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        child: ListView(
          children: [
            Text(widget.includeAuth
                ? "Enter new password, email and old password then click submmit button at top right."
                : "Enter new password then click submmit button at top right."),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  errorText: _submitted == true &&
                          newPasswordController.text.isEmpty
                      ? "Input can't be empty"
                      : _submitted == true &&
                              !validatePassword(newPasswordController)
                          ? 'Password has to be more than 8 character. Minimum 1 upper case, lower case, number and special character.'
                          : null,
                ),
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: confirmNewPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  errorText: _submitted == true &&
                          confirmNewPasswordController.text.isEmpty
                      ? "Input can't be empty"
                      : !_validateConfirmPassword()
                          ? "Password and Confirm Password should have the same value"
                          : null,
                ),
                obscureText: true,
              ),
            ),
            widget.includeAuth
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        errorText:
                            _submitted == true && emailController.text.isEmpty
                                ? "Input can't be empty"
                                : _submitted == true &&
                                        !validateEmail(emailController)
                                    ? "Please enter the correct email"
                                    : null,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: [AutofillHints.email],
                    ),
                  )
                : const SizedBox(),
            widget.includeAuth
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: oldPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Old Password',
                        errorText: _submitted == true &&
                                oldPasswordController.text.isEmpty
                            ? "Input can't be empty"
                            : null,
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  bool _validateEmptyFieldWAuth() {
    return newPasswordController.text.isEmpty ||
            oldPasswordController.text.isEmpty ||
            emailController.text.isEmpty
        ? false
        : true;
  }

  bool _validateEmptyField() {
    return newPasswordController.text.isEmpty ? false : true;
  }

  bool _validateConfirmPassword() {
    return newPasswordController.text == confirmNewPasswordController.text
        ? true
        : false;
  }
}
