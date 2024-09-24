import 'package:fluid_animations/fluid_animations.dart';
import 'package:flutter/animation.dart';

/// Enables creating an [Animation] whose value is defined by a list of
/// of [Keyframe]s.
///
/// {@template keyframe_animation}
///
/// Each [Keyframe] has a duration that defines its percentage of
/// the animation's duration.
///
/// The animation created with this [KeyframeAnimation] interpolates
/// between the different values of the [Keyframe]s.
///
/// The first [Keyframe] interpolates between [startingValue] and its value.
///
/// A [Tween] is created for each [Keyframe]. The tween creation can be changed
/// with [createTween].
///
/// ### Example
///
/// This example defines an animation that starts at 1 then interpolates to 0.8
/// for 20% of the animation's duration using a easing curve. Then it
/// interpolates to 1.4 for 50% of the duration using a spring and then
/// settles back to 1 for the last 30% of the animation using a different
/// spring.

/// ```dart
/// final Animation<double> scaleAnimation = KeyframeAnimation<double>(
///     startingValue: 1,
///     keyframes: const [
///       CurvedKeyframe(
///         value: 0.8,
///         duration: 0.2,
///         curve: Curves.easeIn,
///       ),
///       SpringKeyframe(
///         value: 1.4,
///         duration: 0.5,
///         spring: FluidSpring.bouncy,
///       ),
///       SpringKeyframe(
///         value: 1,
///         duration: 0.3,
///         spring: FluidSpring.smooth,
///         velocity: 2,
///       ),
///     ],
///   ).animate(myAnimationController);
/// ```
///
/// See also:
/// - [LinearKeyframe] a keyframe that uses linear interpolation.
/// - [CurvedKeyframe] a keyframe that uses a bezier curve.
/// - [SpringKeyframe] a keyframe that uses a spring.
/// {@endtemplate}
class KeyframeAnimation<T extends Object> extends Animatable<T> {
  /// Construct a [KeyframeAnimation].
  ///
  /// [keyframes] has to contain at least one item.
  ///
  /// {@macro keyframe_animation}
  KeyframeAnimation({
    required this.keyframes,
    this.createTween,
    this.startingValue,
  }) : assert(keyframes.isNotEmpty, 'You need at least one keyframe.') {
    final tweens = createTweens();
    _sequence = TweenSequence<T>(tweens);
  }

  late final TweenSequence<T> _sequence;

  /// The list of keyframes used for the animation.
  final List<Keyframe<T>> keyframes;

  /// The first value in the animation.
  ///
  /// The first [Keyframe] interpolates between [startingValue] and its value.
  final T? startingValue;

  /// Handles the creation for each tween for the keyframes.
  ///
  /// By default this creates a [Tween].
  ///
  /// For example, this can be used to support custom tweens
  /// like [ColorTween] or [IntTween].
  final Tween<T> Function({T? begin, T? end})? createTween;

  /// Returns a [Duration] that is the sum of all keyframe durations.
  ///
  /// This assumes that a keyframe duration of 1 equals one second.
  ///
  /// This is a convenient method if you prefer to work with
  /// absolute values in keyframes.
  Duration get asSeconds {
    var duration = 0.0;
    for (final frame in keyframes) {
      duration += frame.duration;
    }

    // Convert double to duration
    return Duration(milliseconds: (duration * 1000).round());
  }

  Tween<T> _createDefaultTween({required T? begin, required T? end}) {
    return Tween<T>(begin: begin, end: end);
  }

  Tween<T> _createTween({required T? begin, required T? end}) {
    return createTween?.call(begin: begin, end: end) ??
        _createDefaultTween(begin: begin, end: end);
  }

  /// Creates Sequence tween items from the provided keyframes.
  List<TweenSequenceItem<T>> createTweens() {
    final tweens = <TweenSequenceItem<T>>[];

    for (var i = 0; i < keyframes.length; i++) {
      final currentFrame = keyframes[i];

      final lastValue = i > 0 ? keyframes[i - 1].value : startingValue;

      final tween = _createTween(begin: lastValue, end: currentFrame.value);

      tweens.add(
        TweenSequenceItem<T>(
          tween: currentFrame.chained != null
              ? tween.chain(currentFrame.chained!)
              : tween,
          weight: currentFrame.duration,
        ),
      );
    }

    return tweens;
  }

  @override
  T transform(double t) {
    return _sequence.transform(t);
  }
}

/// A single keyframe in a [KeyframeAnimation].
///
/// {@template keyframe}
/// [value] is the end value of this keyframe.
///
/// [duration] defines its percentage of the animation's duration.
///
/// ### Example
///
/// This example shows a [KeyframeAnimation] with two keyframes.
/// When this is animated with a duration of 1 second, it takes
/// 0.75 seconds to interpolate from 1 to 0 and after that 0.25 seconds
/// to go from 0 to 1.
///```dart
/// final keyframeAnimation = KeyframeAnimation<double>(
///   startingValue: 1,
///   keyframes: const [
///     LinearKeyframe(value: 0, duration: 0.75),
///     LinearKeyframe(value: 1, duration: 0.25),
///   ],
/// );
///```
/// {@endtemplate}
abstract class Keyframe<T> {
  /// Constructs a single [Keyframe].
  ///
  /// {@macro keyframe}
  const Keyframe({
    required this.value,
    required this.duration,
  });

  /// The end value of this [Keyframe]
  final T value;

  /// Defines how long it takes to interpolate to [value]
  ///
  /// [duration] is the percentage of the entire animation's duration.
  final double duration;

  /// Define an chained animation that is added to the [Tween]
  /// created by this animation.
  Animatable<double>? get chained => null;
}

/// A [Keyframe] that uses linear interpolation for its values.
class LinearKeyframe<T> extends Keyframe<T> {
  /// Constructs a [LinearKeyframe]  that uses linear interpolation for
  /// its values.
  const LinearKeyframe({
    required super.value,
    required super.duration,
  });
}

/// A [Keyframe] that uses a bezier curve to interpolate between its values.
class CurvedKeyframe<T> extends Keyframe<T> {
  /// Constructs a [CurvedKeyframe] that uses a bezier curve to interpolate
  /// between its values.
  const CurvedKeyframe({
    required super.value,
    required super.duration,
    required this.curve,
  });

  /// The curve used for interpolation.
  final Curve curve;

  @override
  Animatable<double>? get chained => CurveTween(curve: curve);
}

/// A [Keyframe] that uses a spring to interpolate between its values.
class SpringKeyframe<T> extends Keyframe<T> {
  /// Constructs a [SpringKeyframe] that uses a spring to interpolate
  /// between its values.
  const SpringKeyframe({
    required super.value,
    required super.duration,
    required this.spring,
    this.velocity = 0,
  });

  /// The spring used for interpolation.
  final SpringDescription spring;

  /// The initial velocity of the spring.
  final double velocity;

  @override
  Animatable<double>? get chained =>
      SpringTween(spring: spring, velocity: velocity);
}
