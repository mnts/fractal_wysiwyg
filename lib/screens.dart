import 'package:flutter/material.dart';
import 'package:fractal_gold/models/screen.dart';

import 'notes/NotesScreen.dart';
import 'slides.dart';

final notesScreen = ScreenFractal(
  icon: Icons.note_alt,
  name: 'notes',
  builder: NotesScreen.new,
);

final cyberScreen = ScreenFractal(
  icon: Icons.slideshow,
  name: 'intro',
  builder: CyberSlides.new,
);
