library undraw;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:undraw/fetch_illustration.dart';
import 'package:undraw/illustrations.g.dart';

export 'package:undraw/illustrations.g.dart';

class UnDraw extends StatelessWidget {
  const UnDraw({
    super.key,
    required this.illustration,
    this.color,
    this.semanticLabel,
    this.alignment = Alignment.center,
    this.fit = BoxFit.contain,
    this.height,
    this.width,
    this.placeholder,
    this.errorWidget,
    this.padding,
  });

  /// Enum [UnDrawIllustration] with all supported illustrations
  final UnDrawIllustration illustration;

  /// The color that will replaced for illustration
  final Color? color;

  /// The [Semantics.label] for this picture.
  ///
  /// The value indicates the purpose of the picture, and will be
  /// read out by screen readers.
  final String? semanticLabel;

  /// How to align the picture within its parent widget.
  ///
  /// The alignment aligns the given position in the picture to the given position
  /// in the layout bounds. For example, an [Alignment] alignment of (-1.0,
  /// -1.0) aligns the image to the top-left corner of its layout bounds, while a
  /// [Alignment] alignment of (1.0, 1.0) aligns the bottom right of the
  /// picture with the bottom right corner of its layout bounds. Similarly, an
  /// alignment of (0.0, 1.0) aligns the bottom middle of the image with the
  /// middle of the bottom edge of its layout bounds.
  ///
  /// If the [alignment] is [TextDirection]-dependent (i.e. if it is a
  /// [AlignmentDirectional]), then a [TextDirection] must be available
  /// when the picture is painted.
  ///
  /// Defaults to [Alignment.center].
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final AlignmentGeometry alignment;

  /// How to inscribe the picture into the space allocated during layout.
  /// The default is [BoxFit.contain].
  final BoxFit fit;

  /// If specified, the width to use for the SVG.  If unspecified, the SVG
  /// will take the width of its parent.
  final double? width;

  /// If specified, the height to use for the SVG.  If unspecified, the SVG
  /// will take the height of its parent.
  final double? height;

  /// The widget that will appear during loading illustration from the internet
  final Widget? placeholder;

  /// The widget that will appear if occurs an error
  final Widget? errorWidget;

  /// Empty space to inscribe inside the [decoration]. The [child], if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).colorScheme.primary;

    return FutureBuilder<String>(
      future: getTintedIllustration(illustration, color),
      builder: (context, snapshot) {
        Widget body;

        if (snapshot.hasData) {
          body = SvgPicture.string(
            snapshot.requireData,
            height: height,
            width: width,
            alignment: alignment,
            fit: fit,
            semanticsLabel: semanticLabel,
          );
        } else if (snapshot.hasError) {
          body = errorWidget ?? const Text('Could not load illustration!');
        } else {
          body = placeholder ?? const CircularProgressIndicator();
        }

        return Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(16),
          child: Center(child: body),
        );
      },
    );
  }
}
