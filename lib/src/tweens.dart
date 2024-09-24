import 'dart:ui';

import 'package:fluid_animations/fluid_animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

/// Transforms the value of the given animation by the given spring.
///
/// See also:
/// - [SpringDescription] used to describe the spring
/// - [CurveTween] same as this but for curves.
class SpringTween extends Animatable<double> {
  /// Creates a spring tween.
  SpringTween({required this.spring, double velocity = 0})
      : _simulation = SpringSimulation(spring, 0, 1, velocity);

  /// The spring used for this tween.
  SpringDescription spring;

  final SpringSimulation _simulation;

  @override
  double transform(double t) {
    if (t == 0.0 || t == 1.0) {
      assert(
        _simulation.x(t).round() == t,
        'Finished simulation should equal 1',
      );
      return t;
    }

    return _simulation.x(t);
  }

  @override
  String toString() =>
      '${objectRuntimeType(this, 'SpringTween')}(spring: $spring)';
}

/// A non-linear interpolation between two alignments using two separate spring
/// animations.
///
/// See also:
/// - [SpringSimulation2D], which is responsible for simulating two springs.
/// - [FluidOffsetTween], similar to this but for Offset.
class FluidAlignmentTween extends Tween<Alignment> {
  /// Creates an [Alignment] tween that is driven by a [SpringSimulation2D].
  ///
  /// The `x` and `y` values of [Alignment] are interpolated using two
  /// independent spring simulations.
  ///
  /// The [begin] and [end] properties may be null; the null value
  /// is treated as meaning the center.
  FluidAlignmentTween({
    required this.simulation,
    super.begin,
    super.end,
  });

  /// The simulation used to animate the `x` and `y` values.
  final SpringSimulation2D simulation;

  @override
  Alignment lerp(double t) {
    if (identical(begin, end)) {
      return begin!;
    }
    // Time of the second animation.
    final ty = simulation.y(simulation.deltaTime);
    if (begin == null) {
      return Alignment(
        lerpDouble(0.0, end!.x, t)!,
        lerpDouble(0.0, end!.y, ty)!,
      );
    }
    if (end == null) {
      return Alignment(
        lerpDouble(begin!.x, 0.0, t)!,
        lerpDouble(begin!.y, 0.0, ty)!,
      );
    }
    return Alignment(
      lerpDouble(begin!.x, end!.x, t)!,
      lerpDouble(begin!.y, end!.y, ty)!,
    );
  }
}

/// A non-linear interpolation between two [Offset] values using two separate
/// spring animations.
///
/// See also:
/// - [SpringSimulation2D], which is responsible for simulating two springs.
/// - [FluidAlignmentTween], similar to this but for Alignment.
class FluidOffsetTween extends Tween<Offset> {
  /// Creates an Offset tween that is driven by a [SpringSimulation2D].
  ///
  /// The dx and dy values of Offset are interpolated using two independent
  /// spring simulations.
  FluidOffsetTween({
    required this.simulation,
    super.begin,
    super.end,
  });

  /// The [SpringSimulation2D] used to animate the dx and dy values.
  final SpringSimulation2D simulation;

  @override
  Offset lerp(double t) {
    if (identical(begin, end)) {
      return begin!;
    }

    return Offset(
      lerpDouble(begin!.dx, end!.dx, t)!,
      lerpDouble(begin!.dy, end!.dy, simulation.y(simulation.deltaTime))!,
    );
  }
}
