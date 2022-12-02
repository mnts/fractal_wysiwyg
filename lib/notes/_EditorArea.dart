import 'package:fractals/helpers/random.dart';
import 'package:fractals/models/profile.dart';
import 'package:get_storage/get_storage.dart';
import 'NoteBlock.dart';
import 'package:flutter/material.dart';

import 'ZefyrArea.dart';
import 'text_field_page.dart';

class EditorArea extends StatefulWidget {
  final ProfileFractal? user;
  String? name;

  EditorArea({Key? key, this.name, this.user}) : super(key: key);

  @override
  _EditorAreaState createState() => _EditorAreaState();
}

class _EditorAreaState extends State<EditorArea> {
  bool onEditor = false;
  late String id_list;
  GetStorage box = GetStorage('notes');
  String? currentKey;

  @override
  void initState() {
    super.initState();
    print('initNotes');
    id_list = "list_" + widget.user!.id;
    box.listenKey(id_list, (value) {
      if (mounted) setState(() {});
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Note that the editor requires special `ZefyrScaffold` widget to be
    // one of its parents.
    //return TextFieldScreen(key: Key('baaaa'));

    List<dynamic>? ids = box.read(id_list);

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ClipOval(
                  child: Material(
                    color: Colors.grey, //Color(0x22FFEEFF),
                    child: InkWell(
                      splashColor: Colors.blue,
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        createNote();
                      },
                    ),
                  ),
                ),
                if (ids != null)
                  ...ids.map(
                    (id) {
                      return NoteBlock(
                        key: Key(id),
                        data: box.read(id),
                        onTap: () {
                          setState(() {
                            currentKey = id + '_doc';
                            print(currentKey);
                          });
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
        if (currentKey != null)
          Expanded(
            flex: 8,
            child: TextFieldScreen(key: Key(currentKey!)),
          ),
      ],
    );
  }

  createNote() {
    final String id = getRandomString(5);
    Map<String, dynamic> item = {
      "time_created": DateTime.now().millisecondsSinceEpoch,
    };

    box.write(id, item);

    List<dynamic> list_ids = box.read(id_list) ?? [];
    list_ids.insert(0, id);
    box.write(id_list, list_ids);
  }
  /*

  ZefyrController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ZefyrToolbar.basic(controller: _controller),
      ),
      Expanded(
        child: ZefyrEditor(
          padding: EdgeInsets.all(16),
          controller: _controller,
          focusNode: _focusNode,
        ),
      ),
    ]);
  }

  NotusDocument _loadDocument() {
    final Delta delta = Delta()..insert("Zefyr Quick Start\n");
    return NotusDocument.fromDelta(delta);
  }
  */
}
