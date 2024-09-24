# Fluid Animations

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

Create effortlessly smooth and responsive animations in your Flutter apps inspired by Apple's SwiftUI animations.

![Demo Gif showing 2D Spring based animation](https://github.com/RoundedInfinity/fluid_animations/blob/main/demo/spring_2d.gif?raw=true)

## Features 

- ⚡️ Effortlessly create smooth and responsive spring animations 
- 🎨 Choose from preset animation styles (bouncy, smooth, snappy, interactive, ...) 
- 🔧 Simplify creating smooth animations


## Usage

The simplest way of creating a spring is using the prebuilt ones. For example:
```dart
final mySpring = FluidSpring.bouncy;
```

You can also create custom springs. `FluidSpring` has two properties: `duration` and `bounce`.
```dart
final mySpring = FluidSpring(bounce: 0.4, duration: 0.5);
```
**Duration**: Defines the pace of the spring. This is approximately equal to the settling duration.


**Bounce**: How bouncy the spring should be. A value of 0 indicates no bounces, positive values indicate increasing amounts of bounciness up to a maximum  of 1.0 (corresponding to undamped oscillation), and negative values indicate overdamped springs with a minimum value of -1.0.

### Animating

The simplest way to animate your widgets with a spring is using the `FluidTransitionBuilder`. It animates all changes of `value` using a spring.

```dart
FluidTransitionBuilder<double>(
  value: isHovered ? 200.0 : 100.0,
  spring: FluidSpring.bouncy, // Use a bouncy spring animation
  builder: (animation, child) {
    return Container(
      width: animation.value,
      height: animation.value,
      child: child,
    );
  },
  child: const FlutterLogo()
);
```

When you need more control over your animation you can also use a `AnimationController` and run a spring simulation.
```dart
final spring = FluidSpring.smooth;

final simulation = SpringSimulation(spring, 0, 1, 0);

_controller.animateWith(simulation);
```

See the flutter example on how to [animate a widget using a physics simulation](https://docs.flutter.dev/cookbook/animation/physics-simulation).


### Animate using keyframes

You can also create a complex custom animation using keyframes.

This example defines an animation that starts at 1 then interpolates to 0.8
for 20% of the animation's duration using a easing curve. Then it
interpolates to 1.4 for 50% of the duration using a spring and then
settles back to 1 for the last 30% of the animation using a different
spring.

```dart
final Animation<double> scaleAnimation = KeyframeAnimation<double>(
    startingValue: 1,
    keyframes: const [
      CurvedKeyframe(
        value: 0.8,
        duration: 0.2,
        curve: Curves.easeIn,
      ),
      SpringKeyframe(
        value: 1.4,
        duration: 0.5,
        spring: FluidSpring.bouncy,
      ),
      SpringKeyframe(
        value: 1,
        duration: 0.3,
        spring: FluidSpring.smooth,
        velocity: 2,
      ),
    ],
  ).animate(myAnimationController);
```

### 2D Spring animations

For 2D animations (e.g. animating positions like those seen in the demo video), use the `SpringSimulation2D` class. Refer to the [example](https://github.com/RoundedInfinity/fluid_animations/blob/main/example/lib/main.dart) implementation for guidance.

## Acknowledgements

The math used is based on this [amazing article](https://github.com/jenox/UIKit-Playground/tree/master/01-Demystifying-UIKit-Spring-Animations/).

Values for the prebuilt springs are from the [Apple Documentation](https://developer.apple.com/documentation/swiftui/animation) on animation.

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis

