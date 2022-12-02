import 'package:fractals/models/document.dart';
import 'package:zefyrka/zefyrka.dart';

extension DocumentFractalExt on DocumentFractal {
  NotusDocument? get notus => stuff[44];
  set notus(NotusDocument? doc) => stuff[44] = doc;
}
