import 'dart:typed_data';
import 'dart:ui';

import 'package:crop_your_image/crop_your_image.dart';

import 'package:image/image.dart' hide ImageFormat;

/// an implementation of [ImageCropper] using image package
class ImageImageCropper extends ImageCropper<Image> {
  const ImageImageCropper();

  @override
  RectCropper<Image> get rectCropper => defaultRectCropper;

  @override
  CircleCropper<Image> get circleCropper => defaultCircleCropper;

  @override
  RectValidator<Image> get rectValidator => defaultRectValidator;
}

/// process cropping image.
/// this method is supposed to be called only via compute()
final RectCropper<Image> defaultRectCropper = (
  Image original, {
  required Offset topLeft,
  required Size size,
  required ImageFormat? outputFormat,
}) {
  return _findCropFunc(outputFormat)(
    copyCrop(
      original,
      x: topLeft.dx.toInt(),
      y: topLeft.dy.toInt(),
      width: size.width.toInt(),
      height: size.height.toInt(),
    ),
  );
};

/// process cropping image with circle shape.
/// this method is supposed to be called only via compute()
final CircleCropper<Image> defaultCircleCropper = (
  Image original, {
  required Offset center,
  required double radius,
  required ImageFormat? outputFormat,
}) {
  return _findCropFunc(outputFormat)(
    copyCropCircle(
      original,
      centerX: center.dx.toInt(),
      centerY: center.dy.toInt(),
      radius: radius.toInt(),
    ),
  );
};

Uint8List Function(Image) _findCropFunc(ImageFormat? outputFormat) {
  return switch (outputFormat) {
    ImageFormat.bmp => encodeBmp,
    ImageFormat.ico => encodeIco,
    ImageFormat.jpeg => encodeJpg,
    ImageFormat.png => encodePng,
    _ => encodePng,
  };
}
