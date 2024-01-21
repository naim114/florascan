import 'package:florascan/src/widgets/appbar/appbar_confirm_cancel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class ContentEditor extends StatefulWidget {
  const ContentEditor({
    super.key,
    required this.controller,
    required this.onConfirm,
    required this.title,
  });

  final String title;
  final QuillController controller;
  final Function(
    QuillController quillController,
  ) onConfirm;

  @override
  State<ContentEditor> createState() => _ContentEditorState();
}

class _ContentEditorState extends State<ContentEditor> {
  bool _submitted = false;
  bool _loading = false;

  bool post() {
    setState(() => _submitted = true);
    Navigator.pop(context);

    setState(() => _loading = true);

    Future.delayed(const Duration(seconds: 1), () {
      widget.onConfirm(
        widget.controller,
      );
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarConfirmCancel(
        onCancel: () => Navigator.pop(context),
        onConfirm: post,
        context: context,
        title: widget.title,
      ),
      body: ListView(
        children: [
          ExpansionTile(
            title: const Text(
              "Editor Toolbar (Tap to Hide)",
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            initiallyExpanded: true,
            children: [
              QuillToolbar.simple(
                configurations: QuillSimpleToolbarConfigurations(
                  controller: widget.controller,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
            ),
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: widget.controller,
                readOnly: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
