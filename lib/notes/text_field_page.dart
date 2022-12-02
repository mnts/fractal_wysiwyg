import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quill_format/quill_format.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zefyrka/zefyrka.dart';

class TextFieldScreen extends StatefulWidget {
  Function? onSave;

  TextFieldScreen({Key? key, this.onSave}) : super(key: key);

  @override
  _TextFieldScreenState createState() => _TextFieldScreenState();
}

class _TextFieldScreenState extends State<TextFieldScreen> {
  ZefyrController? _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    var doc = GetStorage().read(widget.key.toString());
    print('Doc: ');
    print(doc);

    print('---------> ' + widget.key.toString());
    print(_controller?.document == null);
    print((doc != null) ? doc : 'none');

    /*
    print('tryyy');
    print(doc);
    print(doc..runtimeType);
    final Delta delta = (doc == null)
        ? (Delta()..insert("\n"))
        : Delta.fromJson(doc as List<dynamic>);
    //final Delta delta = (Delta()..insert("\n"));
    print("great");
    print(delta);
    */

    print(' <---------');
    final document = doc != null
        ? NotusDocument.fromJson(jsonDecode(doc))
        : NotusDocument.fromDelta(Delta()..insert("\n"));
    //
    /*
    final document = (doc == null)
        ? NotusDocument.fromDelta(delta)
        : NotusDocument.fromJson(json.decode(doc));
    */

    _controller = ZefyrController(document);
    _controller!.addListener(_print);

    super.initState();
  }

  /*
  Future<void> loadFromUrl(String url) async {
    try {
      final res = await Ipfs.cat(url);
      final r = await res.bytesToString();
      final doc = NotusDocument.fromJson(jsonDecode(r));
      setState(() {
        _controller = ZefyrController(doc);
      });
    } catch (error) {
      final doc = NotusDocument()..insert(0, '');
      setState(() {
        _controller = ZefyrController(doc);
      });
    }
  }
  */

  Future<void> save() async {
    final data = jsonEncode(_controller!.document);
    GetStorage().write(this.widget.key.toString(), data);
    /*
    final data = jsonEncode(_controller!.document);
    final f = MultipartFile.fromString('file', data);
    final url = await Ipfs.upload(f);
    */
  }

  @override
  void didUpdateWidget(covariant TextFieldScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller!.addListener(_print);
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.removeListener(_print);
  }

  void _print() {
    // print(jsonEncode(_controller.document));
  }

  @override
  Widget build(BuildContext context) {
    //this.dispose();
    return Scaffold(
      appBar: ZefyrToolbar.basic(controller: _controller!),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          save();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400, width: 0),
          ),
          child: ZefyrField(
            controller: _controller!,
            focusNode: _focusNode,
            autofocus: true,
            // readOnly: true,
            padding: EdgeInsets.only(left: 16, right: 16),
            onLaunchUrl: _launchUrl,
          ),
        ),
      ),
    );
  }

  void _launchUrl(String? url) async {
    if (url == null) return;
    final result = await canLaunch(url);
    if (result) {
      await launch(url);
    }
  }
}
