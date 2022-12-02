import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class NoteBlock extends StatefulWidget {
  dynamic data;
  Function? onTap;
  NoteBlock({Key? key, this.data, this.onTap}) : super(key: key);

  @override
  _NoteBlockState createState() => _NoteBlockState();
}

class _NoteBlockState extends State<NoteBlock> {
  @override
  Widget build(BuildContext context) {
    DateTime t =
        DateTime.fromMillisecondsSinceEpoch(widget.data['time_created']);
    return InkWell(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('dd-MM-yyyy kk:mm').format(t),
              textAlign: TextAlign.left,
            ),
            Divider(
              color: Colors.grey,
            ),
            Text(
              widget.data["text"] ?? '',
              maxLines: 5,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
        alignment: Alignment.topLeft,
        margin: EdgeInsets.all(6),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0x22FFEEFF),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
      onTap: widget.onTap as void Function()? ?? () {},
    );
  }
}
