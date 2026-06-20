import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';

/// Decodes the upright pixel size of a captured still (tap-to-scan).
///
/// `ML Kit.fromFilePath()` and `Image.file` both honour EXIF, so boxes and the
/// displayed image are in display-space. But some Android codecs return raw
/// sensor dims (landscape) ignoring EXIF — so if the sensor is rotated 90/270°
/// and we got a landscape image, swap so all coordinate spaces agree (docs §6.3).
Future<Size> decodeUprightStillSize(String path, int sensorOrientation) async {
  final bytes = await File(path).readAsBytes();
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  var w = frame.image.width.toDouble();
  var h = frame.image.height.toDouble();
  if ((sensorOrientation == 90 || sensorOrientation == 270) && w > h) {
    final tmp = w;
    w = h;
    h = tmp;
  }
  return Size(w, h);
}
