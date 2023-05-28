import 'package:flutter/material.dart';

const gradientgreen = Color(0xFF0E7A4E);


CustomColors lightCustomColors = const CustomColors(
  sourceGradientgreen: Color(0xFF0E7A4E),
  gradientgreen: Color(0xFF006D44),
  onGradientgreen: Color(0xFFFFFFFF),
  gradientgreenContainer: Color(0xFF91F7BD),
  onGradientgreenContainer: Color(0xFF002111),
);

CustomColors darkCustomColors = const CustomColors(
  sourceGradientgreen: Color(0xFF0E7A4E),
  gradientgreen: Color(0xFF75DAA3),
  onGradientgreen: Color(0xFF003921),
  gradientgreenContainer: Color(0xFF005232),
  onGradientgreenContainer: Color(0xFF91F7BD),
);



/// Defines a set of custom colors, each comprised of 4 complementary tones.
///
/// See also:
///   * <https://m3.material.io/styles/color/the-color-system/custom-colors>
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.sourceGradientgreen,
    required this.gradientgreen,
    required this.onGradientgreen,
    required this.gradientgreenContainer,
    required this.onGradientgreenContainer,
  });

  final Color? sourceGradientgreen;
  final Color? gradientgreen;
  final Color? onGradientgreen;
  final Color? gradientgreenContainer;
  final Color? onGradientgreenContainer;

  @override
  CustomColors copyWith({
    Color? sourceGradientgreen,
    Color? gradientgreen,
    Color? onGradientgreen,
    Color? gradientgreenContainer,
    Color? onGradientgreenContainer,
  }) {
    return CustomColors(
      sourceGradientgreen: sourceGradientgreen ?? this.sourceGradientgreen,
      gradientgreen: gradientgreen ?? this.gradientgreen,
      onGradientgreen: onGradientgreen ?? this.onGradientgreen,
      gradientgreenContainer: gradientgreenContainer ?? this.gradientgreenContainer,
      onGradientgreenContainer: onGradientgreenContainer ?? this.onGradientgreenContainer,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      sourceGradientgreen: Color.lerp(sourceGradientgreen, other.sourceGradientgreen, t),
      gradientgreen: Color.lerp(gradientgreen, other.gradientgreen, t),
      onGradientgreen: Color.lerp(onGradientgreen, other.onGradientgreen, t),
      gradientgreenContainer: Color.lerp(gradientgreenContainer, other.gradientgreenContainer, t),
      onGradientgreenContainer: Color.lerp(onGradientgreenContainer, other.onGradientgreenContainer, t),
    );
  }

  /// Returns an instance of [CustomColors] in which the following custom
  /// colors are harmonized with [dynamic]'s [ColorScheme.primary].
  ///
  /// See also:
  ///   * <https://m3.material.io/styles/color/the-color-system/custom-colors#harmonization>
  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith(
    );
  }
}