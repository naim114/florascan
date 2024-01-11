import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../models/user_model.dart';
import '../../../services/helpers.dart';
import '../../../widgets/list_tile/list_tile_icon.dart';
import 'update_email.dart';
import 'update_password.dart';

class Security extends StatelessWidget {
  const Security({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: CustomColor.neutral2,
          ),
        ),
        title: Text(
          "Security",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
      ),
      body: ListView(
        children: [
          listTileIcon(
            context: context,
            icon: Icons.email,
            title: "Update Email",
            onTap: () {
              User? firebaseUser = FirebaseAuth.instance.currentUser;

              if (firebaseUser != null) {
                if (firebaseUser.providerData.first.providerId ==
                    'google.com') {
                  Fluttertoast.showToast(
                      msg:
                          'Update email not available for account signed in from google');
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UpdateEmail(user: user),
                    ),
                  );
                }
              }
            },
          ),
          listTileIcon(
            context: context,
            icon: Icons.key,
            title: "Update Password",
            onTap: () {
              User? firebaseUser = FirebaseAuth.instance.currentUser;

              if (firebaseUser != null) {
                if (firebaseUser.providerData.first.providerId ==
                    'google.com') {
                  Fluttertoast.showToast(
                      msg:
                          'Update password not available for account signed in from google');
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UpdatePassword(user: user),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
