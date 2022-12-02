import 'package:flutter/material.dart';
import 'package:fractal_gold/areas/tabs.dart';
import 'package:fractal_gold/models/screen.dart';
import 'package:fractal_gold/screens/fscreen.dart';
import 'package:fractal_word/word.dart';
import 'package:fractals/models/catalog.dart';
import 'package:fractals/models/document.dart';
import 'package:fractals/models/image.dart';
import 'package:provider/provider.dart';

import 'screens/wysiwyg.dart';

class CyberSlides extends StatefulWidget {
  CyberSlides({Key? key}) : super(key: key);

  @override
  _CyberSlidesState createState() => _CyberSlidesState();
}

class _CyberSlidesState extends State<CyberSlides>
    with SingleTickerProviderStateMixin {
  late final TabController ctrl;

  final filter = CatalogFractal<DocumentFractal>.xi();
  @override
  void initState() {
    super.initState();
    //filter['parent_id'].value = 'slides';
  }

  @override
  Widget build(BuildContext context) {
    //final screen = Provider.of<ScreenFractal>(context);
    return DefaultTextStyle(
      style: const TextStyle(
        fontSize: 64,
        shadows: [
          Shadow(
            offset: Offset(4, 4),
            blurRadius: 12,
            color: Colors.black,
          )
        ],
        color: Colors.white,
      ),
      child: TabsArea<DocumentFractal>(
        creator: (val) => val is String
            ? DocumentFractal(
                title: val,
                name: val.toLowerCase().replaceAll(
                      RegExp(r"\s+\b|\b\s"),
                      '_',
                    ),
              )
            : null,
        overlap: true,
        filter: filter,
        tabBuilder: (fractal) => Tab(
          height: 48,
          iconMargin: EdgeInsets.zero,
          child: Text(fractal.title.value),
        ),
        builder: (f) => SlideFractal(f),
      ),
    );
  }
}
