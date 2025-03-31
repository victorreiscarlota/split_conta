import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class AnimatedBottomBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AnimatedBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<AnimatedBottomBar> createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  final List<IconData> _icons = [
    Icons.home,
    Icons.person,
    Icons.settings,
    Icons.local_fire_department,
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _icons.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
        lowerBound: 1.0,
        upperBound: 1.2,
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTap(int index) {
    widget.onTap(index);
    _controllers[index].forward().then((_) => _controllers[index].reverse());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          _icons.length,
          (index) => AnimatedIconButton(
            icon: _icons[index],
            isActive: widget.currentIndex == index,
            controller: _controllers[index],
            onTap: () => _onTap(index),
          ),
        ),
      ),
    );
  }
}

class AnimatedIconButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final AnimationController controller;
  final VoidCallback onTap;

  const AnimatedIconButton({
    super.key,
    required this.icon,
    required this.isActive,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        onEnter: (_) => controller.forward(),
        onExit: (_) => controller.reverse(),
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Transform.scale(
              scale: controller.value,
              child: Icon(
                icon,
                size: 32,
                color: isActive ? Colors.blue : Colors.grey[600],
              ),
            );
          },
        ),
      ),
    );
  }
}