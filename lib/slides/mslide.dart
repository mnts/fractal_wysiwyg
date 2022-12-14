import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:zefyrka/zefyrka.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ReSlide extends StatefulWidget {
  Widget? background;
  String text;
  FutureOr<String?>? Function()? loader;
  FutureOr<bool>? Function(String data)? saver;
  List<Widget> ctrls;
  ReSlide({
    super.key,
    this.text = '',
    this.background,
    this.ctrls = const [],
    this.loader,
    this.saver,
  });
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  State<ReSlide> createState() => _RefractalSlideState();
}

class _RefractalSlideState extends State<ReSlide>
    with AutomaticKeepAliveClientMixin<ReSlide> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    initEmpty();
    super.initState();
    _focused = focusNode.hasFocus;
    focusNode.addListener(_editorFocusChanged);
    load();
  }

  initMatrix() {}

  load() async {
    final cont = await widget.loader?.call() ?? '';

    if (cont.isNotEmpty) {
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
    final json = jsonEncode(_controller!.document.toJson());
    widget.saver?.call(json);
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
    final mq = MediaQuery.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      key: widget._scaffoldKey,
      body: Center(
        child: Stack(children: [
          widget.background ?? Container(),
          Center(
            child: ClipRRect(
              // Clip it cleanly.
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 6),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.canvasColor.withAlpha(180),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  width: min(mq.size.width, 800),
                  child: widget.text.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.all(24),
                          child: MarkdownBody(
                            data: widget.text,
                            selectable: true,
                            styleSheet: MarkdownStyleSheet(
                              p: const TextStyle(
                                fontSize: 18,
                                height: 1.4,
                              ),
                            ),
                          ),
                        )
                      : ZefyrField(
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
          if (widget.saver != null)
            Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    color: theme.canvasColor.withAlpha(200),
                    icon: const Icon(Icons.save),
                    onPressed: () {
                      save();
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.canvasColor.withAlpha(200),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: ZefyrToolbar.basic(controller: _controller!),
                  ),
                ],
              ),
            ),
          if (widget.ctrls.isNotEmpty)
            Positioned(
              top: 70,
              left: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ...widget.ctrls,
                ],
              ),
            ),
          /*
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
          */
        ]),
      ),
    );
  }
}
