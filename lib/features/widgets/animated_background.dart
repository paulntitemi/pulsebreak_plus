import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late List<AnimationController> _particleControllers;
  late List<Animation<Offset>> _particleAnimations;

  @override
  void initState() {
    super.initState();
    _initializeParticles();
  }

  void _initializeParticles() {
    _particleControllers = List.generate(4, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 5000 + (index * 1000)),
        vsync: this,
      );
    });

    _particleAnimations =
        _particleControllers.map((controller) {
          return Tween<Offset>(
            begin: const Offset(0, 1.5),
            end: const Offset(0, -1.5),
          ).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          );
        }).toList();

    // Start animations with different delays
    for (int i = 0; i < _particleControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 500), () {
        if (mounted) {
          _particleControllers[i].repeat();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _particleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Particles
        ...List.generate(4, (index) {
          return AnimatedBuilder(
            animation: _particleAnimations[index],
            builder: (context, child) {
              return Positioned(
                left: MediaQuery.of(context).size.width * (0.2 + (index * 0.2)),
                top:
                    MediaQuery.of(context).size.height *
                    _particleAnimations[index].value.dy,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.particleColor,
                  ),
                ),
              );
            },
          );
        }),

        // Wave effect
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, AppColors.waveColor],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
