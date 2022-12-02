import 'dart:convert';


/*
import 'package:flutter/material.dart';
import 'package:fractal_gold/areas/tabs.dart';
import 'package:fractal_gold/inputs/wysiwyg.dart';
import 'package:fractal_gold/models/app.dart';
import 'package:fractal_gold/screens/fscreen.dart';
import 'package:fractals/models/catalog.dart';
import 'package:fractals/models/document.dart';
import 'package:fractals/models/filter.dart';
import 'package:provider/provider.dart';
import '../models/app.dart';
import 'fscreen.dart';

class NotesScreen extends StatefulWidget {
  NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  //final post = Message();

  final catalog = CatalogFractal<DocumentFractal>.xi();
  @override
  void initState() {
    //catalog.filters.add(FilterFractal.xi({'parent_id': app.id}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FScreen(
      Consumer<AppFractal>(
        builder: (context, app, child) => TabsArea<DocumentFractal>(
          filter: catalog,
          builder: (f) => WysiwygInput(
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
        ),
      ),
    );
    /*
    return TabBarView(
      //physics: BouncingScrollPhysics(),
      children: slides,
    );
    */
  }
}
*/