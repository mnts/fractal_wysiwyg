import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quill_format/quill_format.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zefyrka/zefyrka.dart';

class WysiwygField extends StatefulWidget {
  String json;
  WysiwygField(
    this.json, {
    Key? key,
  }) : super(key: key);

  @override
  State<WysiwygField> createState() => _WysiwygInputState();
}

class _WysiwygInputState extends State<WysiwygField>
    with AutomaticKeepAliveClientMixin<WysiwygField> {
  late TextEditingController _ctrl;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _ctrl = TextEditingController();
    _controller =
        ZefyrController(NotusDocument.fromJson(jsonDecode(widget.json)));
    super.initState();
  }

  final FocusNode _focusNode = FocusNode();
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  late ZefyrController _controller;

  /*
  load() {
    var doc = null;

    final document = doc != null
        ? NotusDocument.fromJson(jsonDecode(doc))
        : NotusDocument.fromDelta(Delta()..insert("\n"));
  }
  */

  @override
  Widget build(BuildContext context) {
    return ZefyrEditor(
      autofocus: false,
      //scrollable: false,
      controller: _controller,
      readOnly: true,
      showCursor: false,
      focusNode: _focusNode,
      padding: EdgeInsets.all(0), //.only(top: 4, left: 16, right: 16),
      onLaunchUrl: _launchUrl,
    );
    /*
        if (acc.fractal != null)
          ElevatedButton(
            child: Text('send'),
            onPressed: () {
              final item = Message();
              item.owner = acc.fractal!.profile!;
              item.text = _ctrl.text;
              widget.post(item);
              _ctrl.text = '';
            },
          ).box.alignTopRight.make()
          */
  }

  void _print() {
    // print(jsonEncode(_controller.document));
  }

  void _launchUrl(String? url) async {
    if (url == null) return;
    final result = await canLaunch(url);
    if (result) {
      await launch(url);
    }
  }
}
