import 'package:fluid_animations/fluid_animations.dart';
import 'package:flutter/material.dart';

class SpringCurveView extends StatefulWidget {
  const SpringCurveView({super.key});

  @override
  State<SpringCurveView> createState() => _SpringCurveViewState();
}

class _SpringCurveViewState extends State<SpringCurveView> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final size = isExpanded ? 400.0 : 200.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spring Curve'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        label: const Text('Expand'),
      ),
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          curve: FluidSpring.bouncy.toCurve,
          height: size,
          width: size,
          color: Colors.blue,
        ),
      ),
    );
  }
}
