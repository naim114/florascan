import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../services/helpers.dart';
import '../../../widgets/appbar/appbar_confirm_cancel.dart';

class UpdateEmail extends StatefulWidget {
  const UpdateEmail({
    super.key,
    this.includeAuth = true,
  });

  final bool includeAuth;

  @override
  State<UpdateEmail> createState() => _UpdateEmailState();
}

class _UpdateEmailState extends State<UpdateEmail> {
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController oldEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _submitted = false;

  @override
  void initState() {
    _submitted = false;
    super.initState();
  }

  @override
  void dispose() {
    newEmailController.dispose();
    oldEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarConfirmCancel(
        title: "Update Email",
        onCancel: () => Navigator.pop(context),
        onConfirm: () async {
          // setState(() => _submitted = true);

          // if (widget.includeAuth) {
          //   if (_validateEmptyFieldWAuth() &&
          //       validateEmail(newEmailController) &&
          //       validateEmail(oldEmailController)) {
          //     final result = await UserServices().updateEmail(
          //       user: widget.user,
          //       oldEmail: oldEmailController.text,
          //       newEmail: newEmailController.text,
          //       password: passwordController.text,
          //       includeAuth: true,
          //     );

          //     if (result == true && context.mounted) {
          //       Fluttertoast.showToast(
          //           msg: "Email Updated. Please refresh to see changes.");
          //       Navigator.pop(context);
          //     }
          //   }
          // } else {
          //   if (_validateEmptyField() && validateEmail(newEmailController)) {
          //     final result = await UserServices().updateEmail(
          //       user: widget.user,
          //       newEmail: newEmailController.text,
          //       password: passwordController.text,
          //       includeAuth: false,
          //     );

          //     if (result == true && context.mounted) {
          //       Fluttertoast.showToast(
          //           msg: "Email Updated. Please refresh to see changes.");
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
                ? "Enter new email, old email and password then click submmit button at top right."
                : "Enter new email then click submmit button at top right."),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: newEmailController,
                decoration: InputDecoration(
                  labelText: 'New Email',
                  errorText: _submitted == true &&
                          newEmailController.text.isEmpty
                      ? "Input can't be empty"
                      : _submitted == true && !validateEmail(newEmailController)
                          ? "Please enter the correct email"
                          : null,
                ),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
              ),
            ),
            widget.includeAuth
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: oldEmailController,
                      decoration: InputDecoration(
                        labelText: 'Old Email',
                        errorText: _submitted == true &&
                                oldEmailController.text.isEmpty
                            ? "Input can't be empty"
                            : _submitted == true &&
                                    !validateEmail(oldEmailController)
                                ? "Please enter the correct email"
                                : null,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                    ),
                  )
                : const SizedBox(),
            widget.includeAuth
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorText: _submitted == true &&
                                passwordController.text.isEmpty
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
    return newEmailController.text.isEmpty ||
            oldEmailController.text.isEmpty ||
            passwordController.text.isEmpty
        ? false
        : true;
  }

  bool _validateEmptyField() {
    return newEmailController.text.isEmpty ? false : true;
  }
}
