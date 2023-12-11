import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:theme_mode_handler/theme_picker_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class CustomColor {
  static const primary = Color(0xFFF28500);
  static const secondary = Color(0xFFFF9D26);
  static const neutral1 = Color(0xFF1C1243);
  static const neutral2 = Color(0xFFA29EB6);
  static const neutral3 = Color(0xFFEFF1F3);
  static const danger = Color(0xFFFE4A49);
  static const success = Color(0xFF47C272);
  static const darkerBg = Color(0xFF242526);
  static const darkBg = Color(0xFF3A3B3C);
}

bool isDarkTheme(context) {
  return Theme.of(context).brightness == Brightness.dark ? true : false;
}

Color getColorByBackground(context) {
  return isDarkTheme(context) ? Colors.white : CustomColor.neutral1;
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
