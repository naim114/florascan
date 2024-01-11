import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/comment_model.dart';
import '../../models/user_model.dart';
import '../../services/comment_services.dart';
import '../../services/helpers.dart';

Widget listTileComment({
  required BuildContext context,
  required CommentModel comment,
  required UserModel currentUser,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: ListTile(
      leading: comment.author!.avatarURL == null
          ? Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.height * 0.05,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image:
                        AssetImage('assets/images/default-profile-picture.png'),
                    fit: BoxFit.cover),
              ),
            )
          : CachedNetworkImage(
              imageUrl: comment.author!.avatarURL!,
              fit: BoxFit.cover,
              imageBuilder: (context, imageProvider) => Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.height * 0.05,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: CupertinoColors.systemGrey,
                highlightColor: CupertinoColors.systemGrey2,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.height * 0.05,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                ),
              ),
              errorWidget: (context, url, error) {
                print("Avatar Error: $error");
                return Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.height * 0.05,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/default-profile-picture.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
      trailing: (currentUser.role != null &&
                  currentUser.role!.name == "user") &&
              (comment.author != null && currentUser.id != comment.author!.id)
          ? null
          : IconButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Delete Comment?'),
                  content: const Text('Select OK to delete.'),
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
                        dynamic delete =
                            await CommentServices().delete(comment: comment);

                        if (delete == true && context.mounted) {
                          Fluttertoast.showToast(msg: "Comment deleted");
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: CustomColor.danger),
                      ),
                    ),
                  ],
                ),
              ),
              icon: const Icon(
                Icons.delete_forever,
                color: CustomColor.danger,
              ),
            ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comment.author == null ? "None" : comment.author!.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            timeAgo(comment.createdAt),
            style: const TextStyle(color: CupertinoColors.systemGrey),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Text(comment.text),
      ),
    ),
  );
}
