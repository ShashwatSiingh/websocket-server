import 'package:flutter/material.dart';

class AnimatedDrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Duration delay;

  const AnimatedDrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: 1.0,
      curve: Curves.easeIn,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}