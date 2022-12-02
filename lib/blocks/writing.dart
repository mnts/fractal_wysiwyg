import 'package:flutter/material.dart';
import 'package:fractal_gold/models/app.dart';
import 'package:fractal_gold/widgets/listen.dart';
import 'package:fractals/models/message.dart';
import 'package:velocity_x/velocity_x.dart';

import '../areas/field.dart';

class WritingBlock extends StatelessWidget {
  Message item;
  WritingBlock(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return WysiwygField(item.text.value);
    return Listen(
      item.refreshed,
      (ctx, child) => HStack([
        InkWell(
          child: Text(
            //(item.owner?['name'].value ?? 'anonymous') + ': ',
            item.name.value,
            style: Theme.of(context).textTheme.headline5,
          ),
          onTap: () {
            AppFractal.active.openProfile(item.owner!);
          },
        ).py8(),
        SizedBox(width: 4),
        WysiwygField(item.text.value).expand(),
      ], crossAlignment: CrossAxisAlignment.start),
    );
  }
}
