import 'dart:convert';
import 'package:flutter/material.dart';
import '/extensions/document.dart';
import 'package:fractals/models/document.dart';
import 'package:zefyrka/zefyrka.dart';

class FractalDocument extends StatefulWidget {
  Widget? alternative;
  FractalDocument(
    this.fractal, {
    Key? key,
    this.alternative,
  }) : super(key: key);
  DocumentFractal fractal;

  @override
  State<FractalDocument> createState() => _FractalDocumentState();
}

class _FractalDocumentState extends State<FractalDocument> {
  late TextEditingController _ctrl;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _ctrl = TextEditingController();

    const json =
        r'[{"insert":"Building a rich text editor"},{"insert":"\n","attributes":{"heading":1}},{"insert":{"_type":"hr","_inline":false}},{"insert":"\n"},{"insert":"https://github.com/memspace/zefyr","attributes":{"a":"https://github.com/memspace/zefyr"}},{"insert":"\nZefyr is the first rich text editor created for Flutter framework.\nHere we go again. This is a very long paragraph of text to test keyboard event handling."},{"insert":"\n","attributes":{"block":"quote"}},{"insert":"Hello world!"},{"insert":"\n","attributes":{"block":"quote"}},{"insert":"So many features"},{"insert":"\n","attributes":{"heading":2}},{"insert":"Example of numbered list:\nMarkdown semantics"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"Modern and light look"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"One more thing"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"And this one is just superb and amazing and awesome"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"I can go on"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"With so many posibilitities around"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"Here we go again. This is a very long paragraph of text to test keyboard event handling."},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"And a couple more"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"Finally the tenth item"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"Whoohooo"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"This is bold text. And the code:\nvoid main() {"},{"insert":"\n","attributes":{"block":"code"}},{"insert":"  print(\"Hello world!\"); // with a very long comment to see soft wrapping"},{"insert":"\n","attributes":{"block":"code"}},{"insert":"}"},{"insert":"\n","attributes":{"block":"code"}},{"insert":"Above we have a block of code.\n"}]';
    //_controller.addListener(_print);
    super.initState();
    (widget.fractal.notus != null) ? initZefyr() : load();
  }

  ZefyrController? _controller;

  load() async {
    final file = widget.fractal.file('document.json');
    final cont = await file.readAsString();
    if (cont.isNotEmpty) {
      //final document = NotusDocument.fromJson(jsonDecode(cont));

      widget.fractal.notus = NotusDocument.fromJson(jsonDecode(cont));
      initZefyr();
    }
  }

  initZefyr() {
    setState(() {
      _controller = ZefyrController(widget.fractal.notus);
    });
  }

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _controller == null
          ? (widget.alternative ?? Container())
          : ZefyrField(
              controller: _controller!,
              focusNode: _focusNode,
              showCursor: false,
              decoration: InputDecoration(),
              readOnly: true,
              padding: EdgeInsets.all(1),
            ),
    );
  }
}
