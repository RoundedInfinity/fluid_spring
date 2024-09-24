import 'package:fluid_animations/fluid_animations.dart';
import 'package:flutter/material.dart';

class KeyframeAnimationView extends StatefulWidget {
  const KeyframeAnimationView({super.key});

  @override
  State<KeyframeAnimationView> createState() => _KeyframeAnimationViewState();
}

class _KeyframeAnimationViewState extends State<KeyframeAnimationView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> scaleAnimation = KeyframeAnimation<double>(
      startingValue: 1,
      keyframes: const [
        CurvedKeyframe(
          value: 0.8,
          duration: 0.3,
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
    ).animate(_controller);

    final Animation<Offset> slideAnimation = KeyframeAnimation<Offset>(
      startingValue: Offset.zero,
      keyframes: const [
        CurvedKeyframe(
          value: Offset(0, 0.2),
          duration: 0.3,
          curve: Curves.easeIn,
        ),
        SpringKeyframe(
          value: Offset(0, -0.8),
          duration: 0.4,
          spring: FluidSpring.bouncy,
        ),
        SpringKeyframe(
          value: Offset(0, 0),
          duration: 0.3,
          spring: FluidSpring.smooth,
          velocity: 2,
        ),
      ],
    ).animate(_controller);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fluid Animations'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.forward(from: 0);
        },
        child: const Text('Play'),
      ),
      body: Center(
        child: SlideTransition(
          position: slideAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: const Icon(Icons.thumb_up_alt_rounded, size: 64),
          ),
        ),
      ),
    );
  }
}
