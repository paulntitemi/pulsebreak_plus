import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({super.key});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 1400),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.8,
        end: 1.2,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();

    // Start animations with delays
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 160), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Transform.scale(
                  scale: _animations[index].value,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.loadingDot,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
