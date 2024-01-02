import 'package:cached_network_image/cached_network_image.dart';
import 'package:country/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../services/helpers.dart';
import '../../../widgets/appbar/appbar_confirm_cancel.dart';
import '../../../widgets/editor/image_uploader.dart';

class Profile extends StatefulWidget {
  final Widget bottomWidget;

  const Profile({
    super.key,
    this.bottomWidget = const SizedBox(),
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  String countryDropdownValue = Countries.abw.number;

  @override
  void initState() {
    // nameController.text = widget.user.name;
    // phoneController.text = widget.user.phone ?? "";
    // addressController.text = widget.user.address ?? "";
    // bioController.text = widget.user.bio ?? "";
    // birthdayController.text = widget.user.birthday != null
    //     ? DateFormat('dd/MM/yyyy')
    //         .format(widget.user.birthday ?? DateTime.now())
    //     : "";

    // if (widget.user.country != null) {
    //   countryDropdownValue = widget.user.country!.number;
    // }

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    birthdayController.dispose();
    addressController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarConfirmCancel(
        onCancel: () => Navigator.pop(context),
        onConfirm: () async {
          // dynamic result = await UserServices().updateDetails(
          //   user: widget.user,
          //   name: nameController.text,
          //   birthday: birthdayController.text == ""
          //       ? null
          //       : DateFormat('dd/MM/yyyy').parse(birthdayController.text),
          //   phone: phoneController.text,
          //   bio: bioController.text,
          //   address: addressController.text,
          //   countryNumber: countryDropdownValue,
          // );

          // if (result == true && context.mounted) {
          //   Fluttertoast.showToast(msg: "Details sucessfully updated.");
          //   Navigator.of(context).pop();
          // }
        },
        title: "Edit Profile",
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: ListView(
          children: [
            // Avatar
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.image_outlined),
                          title: const Text('New avatar'),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ImageUploader(
                                appBarTitle: "Upload New Avatar",
                                onCancel: () => Navigator.of(context).pop(),
                                onConfirm: (imageFile, uploaderContext) async {
                                  // print("Image file: ${imageFile.toString()}");

                                  // Fluttertoast.showToast(
                                  //     msg:
                                  //         "Uploading new avatar. Please wait.");

                                  // Navigator.pop(context);
                                  // Navigator.pop(context);

                                  // final result =
                                  //     await UserServices().updateAvatar(
                                  //   imageFile: imageFile,
                                  //   user: widget.user,
                                  // );

                                  // print("Update Avatar: ${result.toString()}");

                                  // if (result == true) {
                                  //   Fluttertoast.showToast(
                                  //       msg:
                                  //           "Avatar Updated. Please refresh to see changes.");
                                  // }
                                },
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.delete_outline,
                            color: CustomColor.danger,
                          ),
                          title: const Text(
                            'Remove current picture',
                            style: TextStyle(color: CustomColor.danger),
                          ),
                          onTap: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text(
                                  'Are you sure you want to remove your avatar?'),
                              content: const Text(
                                  'Deleted data can\'t be retrieve back. Select OK to delete.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Navigator.pop(context);
                                    // Navigator.pop(context);
                                    // Navigator.pop(context);

                                    // final result =
                                    //     await UserServices().removeAvatar(
                                    //   user: widget.user,
                                    // );

                                    // print(
                                    //     "Remove Avatar: ${result.toString()}");

                                    // if (result == true) {
                                    //   Fluttertoast.showToast(
                                    //       msg:
                                    //           "Avatar Removed. Please refresh to see changes.");
                                    // }
                                  },
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(color: CustomColor.danger),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.height * 0.17,
                  //   child: widget.user.avatarURL == null
                  //       ? Container(
                  //           height: MediaQuery.of(context).size.height * 0.17,
                  //           width: MediaQuery.of(context).size.height * 0.17,
                  //           decoration: const BoxDecoration(
                  //             shape: BoxShape.circle,
                  //             image: DecorationImage(
                  //                 image: AssetImage(
                  //                     'assets/images/default-profile-picture.png'),
                  //                 fit: BoxFit.cover),
                  //           ),
                  //         )
                  //       : CachedNetworkImage(
                  //           imageUrl: widget.user.avatarURL!,
                  //           fit: BoxFit.cover,
                  //           imageBuilder: (context, imageProvider) => Container(
                  //             height: MediaQuery.of(context).size.height * 0.17,
                  //             width: MediaQuery.of(context).size.height * 0.17,
                  //             decoration: BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               image: DecorationImage(
                  //                   image: imageProvider, fit: BoxFit.cover),
                  //             ),
                  //           ),
                  //           placeholder: (context, url) => Shimmer.fromColors(
                  //             baseColor: CupertinoColors.systemGrey,
                  //             highlightColor: CupertinoColors.systemGrey2,
                  //             child: Container(
                  //               height:
                  //                   MediaQuery.of(context).size.height * 0.17,
                  //               width:
                  //                   MediaQuery.of(context).size.height * 0.17,
                  //               decoration: const BoxDecoration(
                  //                 shape: BoxShape.circle,
                  //                 color: Colors.grey,
                  //               ),
                  //             ),
                  //           ),
                  //           errorWidget: (context, url, error) => Container(
                  //             height: MediaQuery.of(context).size.height * 0.17,
                  //             width: MediaQuery.of(context).size.height * 0.17,
                  //             decoration: const BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               image: DecorationImage(
                  //                   image: AssetImage(
                  //                       'assets/images/default-profile-picture.png'),
                  //                   fit: BoxFit.cover),
                  //             ),
                  //           ),
                  //         ),
                  // ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.17,
                    width: MediaQuery.of(context).size.height * 0.17,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/default-profile-picture.png'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'Edit Avatar',
                      style: TextStyle(
                        color: CustomColor.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  // Name
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                  ),
                  // Bio
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: bioController,
                      decoration: const InputDecoration(labelText: 'Bio'),
                    ),
                  ),
                  // Birthday
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: birthdayController,
                      readOnly: true,
                      decoration: const InputDecoration(labelText: 'Birthday'),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now());

                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('dd/MM/yyyy').format(pickedDate);
                          setState(
                              () => birthdayController.text = formattedDate);
                        } else {
                          setState(() => birthdayController.text =
                              DateFormat('dd/MM/yyyy').format(DateTime.now()));
                        }
                      },
                    ),
                  ),
                  // Phone Number
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: phoneController,
                      decoration:
                          const InputDecoration(labelText: 'Phone Number'),
                    ),
                  ),
                  // Address
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: addressController,
                      decoration: const InputDecoration(labelText: 'Address'),
                    ),
                  ),
                  // Country
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      elevation: 0,
                      value: countryDropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      decoration: const InputDecoration(labelText: 'Country'),
                      onChanged: (String? value) {
                        print(value);
                        setState(() => countryDropdownValue = value!);
                      },
                      items: Countries.values.map<DropdownMenuItem<String>>(
                        (Country country) {
                          return DropdownMenuItem<String>(
                            value: country.number,
                            child: Text(
                              country.isoShortName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: widget.bottomWidget,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
