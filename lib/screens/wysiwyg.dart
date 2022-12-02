import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fractals/helpers/random.dart';
import 'package:fractals/models/document.dart';
import 'package:fractals/models/image.dart';
import 'package:fractals/models/message.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zefyrka/zefyrka.dart';
import 'package:fractal_gold/areas/catalog.dart';

class SlideFractal extends StatefulWidget {
  DocumentFractal fractal;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  SlideFractal(this.fractal, {Key? key}) : super(key: key);
  @override
  _SlideFractalState createState() => _SlideFractalState();
}

class _SlideFractalState extends State<SlideFractal>
    with AutomaticKeepAliveClientMixin<SlideFractal> {
  @override
  bool get wantKeepAlive => true;

  String imgUrl = '';

  @override
  void initState() {
    imgUrl = 'https://source.unsplash.com/random/' + getRandomString(10);
    initEmpty();
    super.initState();
    _focused = focusNode.hasFocus;
    focusNode.addListener(_editorFocusChanged);
    load();
  }

  load() async {
    if (widget.fractal != null && widget.fractal.id.isNotBlank) {
      final file = widget.fractal.file('document.json');
      final cont = await file.readAsString();
      if (cont.isNotBlank) {
        try {
          final document = NotusDocument.fromJson(jsonDecode(cont));

          setState(() {
            _controller = ZefyrController(document);
          });
        } catch (e) {
          print(e);
        }
        return;
      }
    }
  }

  initEmpty() {
    final json = r'[{"insert":"\n"}]';
    final doc = NotusDocument.fromJson(jsonDecode(json));
    _controller = ZefyrController(doc);
  }

  @override
  void dispose() {
    super.dispose();
  }

  save() async {
    final file = widget.fractal.file('document.json');
    final json = jsonEncode(_controller!.document.toJson());
    widget.fractal.write(file, json);
  }

  ZefyrController? _controller;
  final FocusNode focusNode = FocusNode();

  late bool _focused;

  void _editorFocusChanged() {
    setState(() {
      _focused = focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: widget._scaffoldKey,
      body: Center(
        child: FocusScope(
          debugLabel: 'Scope',
          autofocus: true,
          child: ZStack([
            Image.network(
              imgUrl,
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
              width: width,
              height: height,
            ),
            Center(
              child: ClipRRect(
                // Clip it cleanly.
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 2),
                  child: Container(
                    width: min(width, 800),
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 4,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xAB2B2B2B),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: ZefyrField(
                      controller: _controller!,
                      focusNode: focusNode,
                      // readOnly: true,
                      padding: const EdgeInsets.only(
                        top: 4,
                        left: 16,
                        right: 16,
                      ),
                      //onLaunchUrl: _launchUrl,
                    ),
                  ),
                ),
              ),
            ),
            if (_focused)
              Positioned(
                bottom: 70,
                left: 0,
                child: Row(
                  children: [
                    IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.save),
                      onPressed: () {
                        save();
                      },
                    ),
                    ZefyrToolbar.basic(controller: _controller!),
                  ],
                ),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                color: Colors.white,
                icon: const Icon(Icons.image),
                onPressed: () {
                  widget._scaffoldKey.currentState!.openEndDrawer();
                },
              ),
            ),
          ]),
        ),
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.grey.withAlpha(100),
        child: CatalogArea(
          initial: widget.fractal.title.value,
          onSelected: (url) {
            setState(() {
              imgUrl = url;
            });
          },
        ),
      ),
    );
  }
}
