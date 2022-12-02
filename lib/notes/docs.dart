import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fractal_gold/areas/tabs.dart';
import 'package:fractal_word/word.dart';
import 'package:fractals/models/catalog.dart';
import 'package:fractals/models/document.dart';
import 'package:fractals/models/filter.dart';
import 'package:fractals/models/image.dart';
import 'package:fractals/models/profile.dart';
import 'package:provider/provider.dart';

import '../areas/wysiwyg.dart';

class DocsArea extends StatefulWidget {
  final ProfileFractal user;
  DocsArea({Key? key, required this.user}) : super(key: key);

  @override
  State<DocsArea> createState() => _DocsAreaState();
}

class _DocsAreaState extends State<DocsArea> {
  final catalog = CatalogFractal<DocumentFractal>.xi();
  @override
  void initState() {
    catalog.filters.add(FilterFractal.xi({'parent_id': widget.user.id}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabsArea<DocumentFractal>(
      filter: catalog,
      creator: (val) => val is String
          ? DocumentFractal(
              title: val,
              name: val.toLowerCase().replaceAll(
                    RegExp(r"\s+\b|\b\s"),
                    '_',
                  ),
            )
          : null,
      builder: (f) => WysiwygInput(
        key: Key('wysiwyg_' + f.id),
        fractal: f,
        onSave: (post) {
          f.write(
            f.file('document.json'),
            jsonEncode(
              f.toJson(),
            ),
          );
          f.save();
        },
      ),
    );
  }
}
