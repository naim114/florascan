import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:theme_mode_handler/theme_picker_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;

class CustomColor {
  static const primary = Color(0xFF679668);
  static const secondary = Color(0xFF85AB86);
  static const neutral1 = Color(0xFF1C1243);
  static const neutral2 = Color(0xFFA29EB6);
  static const neutral3 = Color(0xFFEFF1F3);
  static const danger = Color(0xFFFE4A49);
  static const success = Color(0xFF47C272);
  static const darkerBg = Color(0xFF242526);
  static const darkBg = Color(0xFF3A3B3C);
  static const bg = Color(0xFF3A3B3C);
  static const primaryShade = Color(0xFFF0F5EC);
  static const primaryDarkShade = Color(0xFF1C271C);
}

class CustomColorShades {
  static MaterialColor primary() {
    Color color = CustomColor.primary;
    return MaterialColor(color.value, <int, Color>{
      50: color.withOpacity(0.1),
      100: color.withOpacity(0.2),
      200: color.withOpacity(0.3),
      300: color.withOpacity(0.4),
      400: color.withOpacity(0.5),
      500: color.withOpacity(0.6),
      600: color.withOpacity(0.7),
      700: color.withOpacity(0.8),
      800: color.withOpacity(0.9),
      900: color.withOpacity(1.0),
    });
  }
}

bool isDarkTheme(context) {
  return Theme.of(context).brightness == Brightness.dark ? true : false;
}

Color getColorByBackground(context) {
  return isDarkTheme(context) ? Colors.white : CustomColor.neutral1;
}

Color getBgColorByBackground(context) {
  return isDarkTheme(context) ? CustomColor.bg : Colors.white;
}

void selectThemeMode(BuildContext context) async {
  final newThemeMode = await showThemePickerDialog(context: context);
  debugPrint(newThemeMode.toString());
}

Future<void> goToURL({
  required Uri url,
  required BuildContext context,
}) async {
  if (!await launchUrl(url)) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Could not launch $url'),
    ));
    throw Exception('Could not launch $url');
  }
}

bool validateEmail(TextEditingController emailController) {
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final regex = RegExp(pattern);

  return regex.hasMatch(emailController.text);
}

bool validatePassword(TextEditingController passwordController) {
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  return regex.hasMatch(passwordController.text);
}

extension ListExtension<E> on List<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) {
    return Map.fromEntries(
      groupByMapEntries(keyFunction),
    );
  }

  Iterable<MapEntry<K, List<E>>> groupByMapEntries<K>(
      K Function(E) keyFunction) sync* {
    final groups = <K, List<E>>{};
    for (final element in this) {
      final key = keyFunction(element);
      if (!groups.containsKey(key)) {
        groups[key] = <E>[];
      }
      groups[key]!.add(element);
    }
    yield* groups.entries;
  }
}

Future<File?> downloadFile(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}';
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }
  return null;
}

String timeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 365) {
    final years = (difference.inDays / 365).floor();
    return '$years year${years > 1 ? "s" : ""} ago';
  } else if (difference.inDays > 30) {
    final months = (difference.inDays / 30).floor();
    return '$months month${months > 1 ? "s" : ""} ago';
  } else if (difference.inDays > 0) {
    final days = difference.inDays;
    return '$days day${days > 1 ? "s" : ""} ago';
  } else if (difference.inHours > 0) {
    final hours = difference.inHours;
    return '$hours hour${hours > 1 ? "s" : ""} ago';
  } else if (difference.inMinutes > 0) {
    final minutes = difference.inMinutes;
    return '$minutes minute${minutes > 1 ? "s" : ""} ago';
  } else {
    return 'Just now';
  }
}

void openImageViewerDialog({
  required BuildContext context,
  required ImageProvider<Object> imageProvider,
  PhotoViewHeroAttributes? heroAttributes,
}) =>
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            color: Colors.transparent,
            child: PhotoView(
              loadingBuilder: (context, i) => Shimmer.fromColors(
                baseColor: CupertinoColors.systemGrey,
                highlightColor: CupertinoColors.systemGrey2,
                child: Container(
                  color: Colors.grey,
                  height: 200,
                  width: 200,
                ),
              ),
              tightMode: true,
              imageProvider: imageProvider,
              heroAttributes: heroAttributes,
            ),
          ),
        );
      },
    );

Future<ui.Image> fileToUiImage(
    File file, int targetWidth, int targetHeight) async {
  // Read the image file as bytes
  final Uint8List imageBytes = await file.readAsBytes();

  // Decode the image using the `image` package
  img.Image? decodedImage = img.decodeImage(imageBytes);

  if (decodedImage == null) {
    throw Exception('Unable to decode image');
  }

  // Resize the image to target dimensions
  decodedImage =
      img.copyResize(decodedImage, width: targetWidth, height: targetHeight);

  // Convert the resized image to a `ui.Image`
  final ui.Codec codec = await ui
      .instantiateImageCodec(Uint8List.fromList(img.encodePng(decodedImage)));
  final ui.FrameInfo frameInfo = await codec.getNextFrame();

  return frameInfo.image;
}

Future<Float32List> uiImageToFloat32List(ui.Image image) async {
  final int width = image.width;
  final int height = image.height;

  // Convert the ui.Image to a ByteData object
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  if (byteData == null) {
    throw Exception('Unable to convert image to ByteData');
  }

  // Convert the ByteData to a Uint8List
  final Uint8List byteBuffer = byteData.buffer.asUint8List();

  // Create a Float32List to store the normalized pixel values
  final Float32List floatData = Float32List(width * height * 3);

  // Extract RGB channels and normalize the pixel values
  for (int i = 0, j = 0; i < byteBuffer.length; i += 4, j += 3) {
    floatData[j] = byteBuffer[i] / 255.0; // Red channel
    floatData[j + 1] = byteBuffer[i + 1] / 255.0; // Green channel
    floatData[j + 2] = byteBuffer[i + 2] / 255.0; // Blue channel
  }

  return floatData;
}
