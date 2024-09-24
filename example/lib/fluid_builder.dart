import 'package:fluid_animations/fluid_animations.dart';
import 'package:flutter/material.dart';

class FluidBuilderPage extends StatelessWidget {
  const FluidBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fluid Demo'),
      ),
      body: const FluidBuilderDemo(),
    );
  }
}

class FluidBuilderDemo extends StatefulWidget {
  const FluidBuilderDemo({super.key});

  @override
  State<FluidBuilderDemo> createState() => _FluidBuilderDemoState();
}

class _FluidBuilderDemoState extends State<FluidBuilderDemo> {
  Alignment _alignment = Alignment.topLeft;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            height: 600,
            width: 500,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: FluidTransitionBuilder(
              value: _alignment,
              spring: FluidSpring.bouncy,
              builder: (animation, child) {
                return AlignTransition(
                  alignment: animation,
                  child: child!,
                );
              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
        OverflowBar(
          children: [
            FilledButton(
              onPressed: () {
                setState(() {
                  _alignment = Alignment.topLeft;
                });
              },
              child: const Text('Top Left'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _alignment = Alignment.topRight;
                });
              },
              child: const Text('Top Right'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _alignment = Alignment.bottomLeft;
                });
              },
              child: const Text('Bottom Left'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _alignment = Alignment.bottomRight;
                });
              },
              child: const Text('Bottom Right'),
            )
          ],
        )
      ],
    );
  }
}
