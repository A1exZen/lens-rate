import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Degrees to rotate for each device orientation (Android compensation).
const _orientations = {
  DeviceOrientation.portraitUp: 0,
  DeviceOrientation.landscapeLeft: 90,
  DeviceOrientation.portraitDown: 180,
  DeviceOrientation.landscapeRight: 270,
};

/// A streamed frame turned into an ML Kit [InputImage] plus the upright image
/// size its bounding boxes are reported in.
typedef LiveFrame = ({InputImage input, Size uprightSize});

/// Builds an ML Kit [InputImage] from a streamed [CameraImage] for live scanning
/// (docs §6.3 P1). Requires the controller be configured with a single-plane
/// format — `nv21` on Android, `bgra8888` on iOS. Returns null for frames whose
/// rotation or format can't be handled (skip them).
LiveFrame? buildLiveFrame(
  CameraImage image,
  CameraController controller,
  CameraDescription camera,
) {
  final sensorOrientation = camera.sensorOrientation;
  InputImageRotation? rotation;
  if (Platform.isIOS) {
    rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
  } else {
    var compensation = _orientations[controller.value.deviceOrientation] ?? 0;
    // Back camera subtracts, front adds (front is mirrored).
    compensation = camera.lensDirection == CameraLensDirection.front
        ? (sensorOrientation + compensation) % 360
        : (sensorOrientation - compensation + 360) % 360;
    rotation = InputImageRotationValue.fromRawValue(compensation);
  }
  if (rotation == null) return null;

  final format = InputImageFormatValue.fromRawValue(image.format.raw);
  if (format == null || image.planes.length != 1) return null;
  final plane = image.planes.first;

  final input = InputImage.fromBytes(
    bytes: plane.bytes,
    metadata: InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      format: format,
      bytesPerRow: plane.bytesPerRow,
    ),
  );

  // ML Kit reports boxes in the upright (rotated) space: at 90/270° the
  // width and height swap relative to the raw sensor frame.
  final rotated = rotation == InputImageRotation.rotation90deg ||
      rotation == InputImageRotation.rotation270deg;
  final uprightSize = rotated
      ? Size(image.height.toDouble(), image.width.toDouble())
      : Size(image.width.toDouble(), image.height.toDouble());

  return (input: input, uprightSize: uprightSize);
}
